# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/xuanzhaogao/code/TropicalGemm_Cuda

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/xuanzhaogao/code/TropicalGemm_Cuda/build

# Include any dependencies generated for this target.
include CMakeFiles/_TropicalMaxMul_FP32.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/_TropicalMaxMul_FP32.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/_TropicalMaxMul_FP32.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/_TropicalMaxMul_FP32.dir/flags.make

CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.o: CMakeFiles/_TropicalMaxMul_FP32.dir/flags.make
CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.o: ../tropicalgemm_kernels.cu
CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.o: CMakeFiles/_TropicalMaxMul_FP32.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/xuanzhaogao/code/TropicalGemm_Cuda/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CUDA object CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.o"
	/opt/nvidia/hpc_sdk/Linux_x86_64/23.5/compilers/bin/nvcc -forward-unknown-to-host-compiler $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -MD -MT CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.o -MF CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.o.d -x cu -c /home/xuanzhaogao/code/TropicalGemm_Cuda/tropicalgemm_kernels.cu -o CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.o

CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

# Object files for target _TropicalMaxMul_FP32
_TropicalMaxMul_FP32_OBJECTS = \
"CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.o"

# External object files for target _TropicalMaxMul_FP32
_TropicalMaxMul_FP32_EXTERNAL_OBJECTS =

../lib/lib_TropicalMaxMul_FP32.so: CMakeFiles/_TropicalMaxMul_FP32.dir/tropicalgemm_kernels.cu.o
../lib/lib_TropicalMaxMul_FP32.so: CMakeFiles/_TropicalMaxMul_FP32.dir/build.make
../lib/lib_TropicalMaxMul_FP32.so: CMakeFiles/_TropicalMaxMul_FP32.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/xuanzhaogao/code/TropicalGemm_Cuda/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CUDA shared library ../lib/lib_TropicalMaxMul_FP32.so"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/_TropicalMaxMul_FP32.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/_TropicalMaxMul_FP32.dir/build: ../lib/lib_TropicalMaxMul_FP32.so
.PHONY : CMakeFiles/_TropicalMaxMul_FP32.dir/build

CMakeFiles/_TropicalMaxMul_FP32.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/_TropicalMaxMul_FP32.dir/cmake_clean.cmake
.PHONY : CMakeFiles/_TropicalMaxMul_FP32.dir/clean

CMakeFiles/_TropicalMaxMul_FP32.dir/depend:
	cd /home/xuanzhaogao/code/TropicalGemm_Cuda/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/xuanzhaogao/code/TropicalGemm_Cuda /home/xuanzhaogao/code/TropicalGemm_Cuda /home/xuanzhaogao/code/TropicalGemm_Cuda/build /home/xuanzhaogao/code/TropicalGemm_Cuda/build /home/xuanzhaogao/code/TropicalGemm_Cuda/build/CMakeFiles/_TropicalMaxMul_FP32.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/_TropicalMaxMul_FP32.dir/depend

