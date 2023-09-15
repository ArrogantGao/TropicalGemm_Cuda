#include <stdio.h>
#include <stdlib.h>

#include <cstdint>
#include <cstdlib>
#include <cstdio>
#include <cmath>
#include <vector>

// CUDA runtime
#include <cuda_runtime.h>
#include <cublas_v2.h>


// cal offset from row col and ld , in col-major matrix, ld is the width of the matrix
#define OFFSET(row, col, ld) ((col) * (ld) + (row))


#define OPERATOR_ADD(a, b) (a && b)
#define OPERATOR_MUT(a, b) (a || b)
#define PADDING true

// GEMM for Col-Major matrix
// default of julia is Col-Major and default of C++ is Row-Major
template <
    const int BLOCK_SIZE_M,  // width of block of C that each thread block calculate
    const int BLOCK_SIZE_K,  // height of block of A that each thread block load into shared memory
    const int BLOCK_SIZE_N,  // height of block of C that each thread block calculate
    const int THREAD_SIZE_M, // height of block of C that each thread calculate
    const int THREAD_SIZE_N,  // width of block of C that each thread calculate
    const bool ENABLE_DOUBLE_BUFFER // whether enable double buffering or not
    > 
__global__ void Bool_andor_kernel( 
    bool * __restrict__ A,
    bool * __restrict__ B,
    bool * __restrict__ C,
    int M,
    int N,
    int K
    ) {
    
    // size of thread block
    const int bszm = BLOCK_SIZE_M / THREAD_SIZE_M;
    const int bszn = BLOCK_SIZE_N / THREAD_SIZE_N;
    const int THREAD_NUM_PER_BLOCK = bszm * bszn;

    const int BLOCK_SIZE_MK = BLOCK_SIZE_M * BLOCK_SIZE_K;
    const int BLOCK_SIZE_KN = BLOCK_SIZE_K * BLOCK_SIZE_N;
    const int THREAD_SIZE_MN = THREAD_SIZE_M * THREAD_SIZE_N;

    // thread id
    const int tid = threadIdx.y * bszm + threadIdx.x;

    // shared memory
    // directly use 1d shared memory to avoid the conflict of col-major and row-major
    __shared__ bool As[BLOCK_SIZE_MK]; // avoid bank conflict
    __shared__ bool Bs[BLOCK_SIZE_KN];

    // registers for C
    bool accum[THREAD_SIZE_MN] = {0};
    bool A_reg[THREAD_SIZE_M] = {0};
    bool B_reg[THREAD_SIZE_N] = {0};
    
    // row number and col number that needs to be loaded blockIdx.y this thread
    const int A_TILE_COL = tid / BLOCK_SIZE_M;
    const int B_TILE_COL = tid / BLOCK_SIZE_K;

    const int A_TILE_ROW = tid % BLOCK_SIZE_M;
    const int B_TILE_ROW = tid % BLOCK_SIZE_K;
    
    // col stride that thread uses to load multiple rows of a tile
    // how many cols that the threads load in one iteration
    const int A_TILE_COL_STRIDE = THREAD_NUM_PER_BLOCK / BLOCK_SIZE_M;
    const int B_TILE_COL_STRIDE = THREAD_NUM_PER_BLOCK / BLOCK_SIZE_K;

    // number of threads in M and N direction (used when calculating C)
    // const int A_S = BLOCK_SIZE_M / THREAD_SIZE_M;
    // const int B_S = BLOCK_SIZE_N / THREAD_SIZE_N;

    for (int tile_idx = 0 ; tile_idx < K ; tile_idx += BLOCK_SIZE_K) {

        // load A from global memory to shared memory
        #pragma unroll
        for ( int i = 0 ; i < BLOCK_SIZE_K ; i += A_TILE_COL_STRIDE) {
            const int row = BLOCK_SIZE_M * blockIdx.x + A_TILE_ROW ;
            const int col = A_TILE_COL + i + tile_idx;
            if (blockIdx.x == gridDim.x -1 || blockIdx.y == gridDim.y - 1) {
                As[OFFSET(A_TILE_ROW, i + A_TILE_COL, BLOCK_SIZE_M)] = row < M && col < K ? A[OFFSET(row, col, M)] : PADDING;
                // printf("%d, %d, %d, %d, %d, %d, %f\n", blockIdx.x, gridDim.x -1, blockIdx.y, gridDim.y - 1, row, col, As[OFFSET(A_TILE_ROW, i + A_TILE_COL, BLOCK_SIZE_M)]);
            } else {
                As[OFFSET(A_TILE_ROW, i + A_TILE_COL, BLOCK_SIZE_M)] = A[OFFSET(row, col, M)];
            }
        }

        // load B from global memory to shared memory
        #pragma unroll
        for ( int i = 0 ; i < BLOCK_SIZE_N; i += B_TILE_COL_STRIDE) {
            const int row = tile_idx + B_TILE_ROW;
            const int col = BLOCK_SIZE_N * blockIdx.y + i + B_TILE_COL;
            if (blockIdx.x == gridDim.x -1 || blockIdx.y == gridDim.y - 1) {
                Bs[OFFSET(B_TILE_ROW, i + B_TILE_COL, BLOCK_SIZE_K)] = row < K && col < N ? B[OFFSET(row, col, K)] : PADDING;
            } else {
                Bs[OFFSET(B_TILE_ROW, i + B_TILE_COL, BLOCK_SIZE_K)] = B[OFFSET(row, col, K)];
            }
        }

        __syncthreads();

        // compute c
        #pragma unroll
        for (int k = 0; k < BLOCK_SIZE_K; ++ k) {

            // load A and B from shared memory to registers
            #pragma unroll
            for (int thread_m = 0; thread_m < THREAD_SIZE_M; ++thread_m) {
                A_reg[thread_m] = As[OFFSET(threadIdx.x * THREAD_SIZE_M + thread_m, k, BLOCK_SIZE_M)];
            }

            #pragma unroll
            for (int thread_n = 0; thread_n < THREAD_SIZE_N; ++thread_n) {
                B_reg[thread_n] = Bs[OFFSET(k, threadIdx.y * THREAD_SIZE_N + thread_n, BLOCK_SIZE_K)];
            }

            #pragma unroll
            for (int thread_m = 0; thread_m < THREAD_SIZE_M; ++thread_m) {
                #pragma unroll
                for (int thread_n = 0; thread_n < THREAD_SIZE_N; ++thread_n) {
                    accum[OFFSET(thread_m, thread_n, THREAD_SIZE_M)] = OPERATOR_ADD(OPERATOR_MUT(A_reg[thread_m], B_reg[thread_n]), accum[OFFSET(thread_m, thread_n, THREAD_SIZE_M)]);
                }
            }
            
        }
        __syncthreads();
    }

    // store back to C
    #pragma unroll
    for (int thread_n = 0; thread_n < THREAD_SIZE_N; ++thread_n) {
        #pragma unroll
        for (int thread_m = 0; thread_m < THREAD_SIZE_M; ++thread_m) {
            const int col = BLOCK_SIZE_N * blockIdx.y + THREAD_SIZE_N * threadIdx.y + thread_n;
            const int row = BLOCK_SIZE_M * blockIdx.x + THREAD_SIZE_M * threadIdx.x + thread_m;
            if (blockIdx.x == gridDim.x -1 || blockIdx.y == gridDim.y - 1) {
                if (row < M && col < N) {
                    C[OFFSET(row, col, M)] = OPERATOR_ADD(accum[OFFSET(thread_m, thread_n, THREAD_SIZE_M)], C[OFFSET(row, col, M)]);
                }
            } else {
                C[OFFSET(row, col, M)] = OPERATOR_ADD(accum[OFFSET(thread_m, thread_n, THREAD_SIZE_M)], C[OFFSET(row, col, M)]);
            }
        }
    }
}


extern "C"
void Bool_andor(const int m, const int n, const int k, bool *d_A, bool *d_B, bool *d_C){

    const int BLOCK_SIZE_M = 128;
    const int BLOCK_SIZE_K = 8;
    const int BLOCK_SIZE_N = 128;
    const int THREAD_SIZE_M = 8;
    const int THREAD_SIZE_N = 8;
    const bool ENABLE_DOUBLE_BUFFER = false;

    dim3 dimBlock(BLOCK_SIZE_M / THREAD_SIZE_M, BLOCK_SIZE_N / THREAD_SIZE_N);
    dim3 dimGrid(m / BLOCK_SIZE_M, n / BLOCK_SIZE_N);
    if (m % BLOCK_SIZE_M != 0)
        dimGrid.x++;
    if (n % BLOCK_SIZE_N != 0)
        dimGrid.y++;

    Bool_andor_kernel<BLOCK_SIZE_M, BLOCK_SIZE_K, BLOCK_SIZE_N, THREAD_SIZE_M, THREAD_SIZE_N, ENABLE_DOUBLE_BUFFER> 
        <<< dimGrid, dimBlock >>>(d_A, d_B, d_C, m, n, k);

}