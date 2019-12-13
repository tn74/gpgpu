# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
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
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/nvidia/Documents/dbs/gpgpu/cudamodel

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/nvidia/Documents/dbs/gpgpu/cudamodel

# Include any dependencies generated for this target.
include CMakeFiles/dbmain.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/dbmain.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/dbmain.dir/flags.make

CMakeFiles/dbmain.dir/main.cu.o: CMakeFiles/dbmain.dir/flags.make
CMakeFiles/dbmain.dir/main.cu.o: main.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/Documents/dbs/gpgpu/cudamodel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CUDA object CMakeFiles/dbmain.dir/main.cu.o"
	/usr/local/cuda-10.0/bin/nvcc  $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -x cu -c /home/nvidia/Documents/dbs/gpgpu/cudamodel/main.cu -o CMakeFiles/dbmain.dir/main.cu.o

CMakeFiles/dbmain.dir/main.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/dbmain.dir/main.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/dbmain.dir/main.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/dbmain.dir/main.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

CMakeFiles/dbmain.dir/main.cu.o.requires:

.PHONY : CMakeFiles/dbmain.dir/main.cu.o.requires

CMakeFiles/dbmain.dir/main.cu.o.provides: CMakeFiles/dbmain.dir/main.cu.o.requires
	$(MAKE) -f CMakeFiles/dbmain.dir/build.make CMakeFiles/dbmain.dir/main.cu.o.provides.build
.PHONY : CMakeFiles/dbmain.dir/main.cu.o.provides

CMakeFiles/dbmain.dir/main.cu.o.provides.build: CMakeFiles/dbmain.dir/main.cu.o


CMakeFiles/dbmain.dir/src/gating.cu.o: CMakeFiles/dbmain.dir/flags.make
CMakeFiles/dbmain.dir/src/gating.cu.o: src/gating.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/Documents/dbs/gpgpu/cudamodel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CUDA object CMakeFiles/dbmain.dir/src/gating.cu.o"
	/usr/local/cuda-10.0/bin/nvcc  $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -x cu -c /home/nvidia/Documents/dbs/gpgpu/cudamodel/src/gating.cu -o CMakeFiles/dbmain.dir/src/gating.cu.o

CMakeFiles/dbmain.dir/src/gating.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/dbmain.dir/src/gating.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/dbmain.dir/src/gating.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/dbmain.dir/src/gating.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

CMakeFiles/dbmain.dir/src/gating.cu.o.requires:

.PHONY : CMakeFiles/dbmain.dir/src/gating.cu.o.requires

CMakeFiles/dbmain.dir/src/gating.cu.o.provides: CMakeFiles/dbmain.dir/src/gating.cu.o.requires
	$(MAKE) -f CMakeFiles/dbmain.dir/build.make CMakeFiles/dbmain.dir/src/gating.cu.o.provides.build
.PHONY : CMakeFiles/dbmain.dir/src/gating.cu.o.provides

CMakeFiles/dbmain.dir/src/gating.cu.o.provides.build: CMakeFiles/dbmain.dir/src/gating.cu.o


CMakeFiles/dbmain.dir/src/THNeuron.cu.o: CMakeFiles/dbmain.dir/flags.make
CMakeFiles/dbmain.dir/src/THNeuron.cu.o: src/THNeuron.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/Documents/dbs/gpgpu/cudamodel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CUDA object CMakeFiles/dbmain.dir/src/THNeuron.cu.o"
	/usr/local/cuda-10.0/bin/nvcc  $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -x cu -c /home/nvidia/Documents/dbs/gpgpu/cudamodel/src/THNeuron.cu -o CMakeFiles/dbmain.dir/src/THNeuron.cu.o

CMakeFiles/dbmain.dir/src/THNeuron.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/dbmain.dir/src/THNeuron.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/dbmain.dir/src/THNeuron.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/dbmain.dir/src/THNeuron.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

CMakeFiles/dbmain.dir/src/THNeuron.cu.o.requires:

.PHONY : CMakeFiles/dbmain.dir/src/THNeuron.cu.o.requires

CMakeFiles/dbmain.dir/src/THNeuron.cu.o.provides: CMakeFiles/dbmain.dir/src/THNeuron.cu.o.requires
	$(MAKE) -f CMakeFiles/dbmain.dir/build.make CMakeFiles/dbmain.dir/src/THNeuron.cu.o.provides.build
.PHONY : CMakeFiles/dbmain.dir/src/THNeuron.cu.o.provides

CMakeFiles/dbmain.dir/src/THNeuron.cu.o.provides.build: CMakeFiles/dbmain.dir/src/THNeuron.cu.o


CMakeFiles/dbmain.dir/src/STNNeuron.cu.o: CMakeFiles/dbmain.dir/flags.make
CMakeFiles/dbmain.dir/src/STNNeuron.cu.o: src/STNNeuron.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/Documents/dbs/gpgpu/cudamodel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CUDA object CMakeFiles/dbmain.dir/src/STNNeuron.cu.o"
	/usr/local/cuda-10.0/bin/nvcc  $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -x cu -c /home/nvidia/Documents/dbs/gpgpu/cudamodel/src/STNNeuron.cu -o CMakeFiles/dbmain.dir/src/STNNeuron.cu.o

CMakeFiles/dbmain.dir/src/STNNeuron.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/dbmain.dir/src/STNNeuron.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/dbmain.dir/src/STNNeuron.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/dbmain.dir/src/STNNeuron.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

CMakeFiles/dbmain.dir/src/STNNeuron.cu.o.requires:

.PHONY : CMakeFiles/dbmain.dir/src/STNNeuron.cu.o.requires

CMakeFiles/dbmain.dir/src/STNNeuron.cu.o.provides: CMakeFiles/dbmain.dir/src/STNNeuron.cu.o.requires
	$(MAKE) -f CMakeFiles/dbmain.dir/build.make CMakeFiles/dbmain.dir/src/STNNeuron.cu.o.provides.build
.PHONY : CMakeFiles/dbmain.dir/src/STNNeuron.cu.o.provides

CMakeFiles/dbmain.dir/src/STNNeuron.cu.o.provides.build: CMakeFiles/dbmain.dir/src/STNNeuron.cu.o


CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o: CMakeFiles/dbmain.dir/flags.make
CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o: src/GPeNeuron.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/Documents/dbs/gpgpu/cudamodel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CUDA object CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o"
	/usr/local/cuda-10.0/bin/nvcc  $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -x cu -c /home/nvidia/Documents/dbs/gpgpu/cudamodel/src/GPeNeuron.cu -o CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o

CMakeFiles/dbmain.dir/src/GPeNeuron.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/dbmain.dir/src/GPeNeuron.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/dbmain.dir/src/GPeNeuron.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/dbmain.dir/src/GPeNeuron.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o.requires:

.PHONY : CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o.requires

CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o.provides: CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o.requires
	$(MAKE) -f CMakeFiles/dbmain.dir/build.make CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o.provides.build
.PHONY : CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o.provides

CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o.provides.build: CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o


CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o: CMakeFiles/dbmain.dir/flags.make
CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o: src/GPiNeuron.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/Documents/dbs/gpgpu/cudamodel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CUDA object CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o"
	/usr/local/cuda-10.0/bin/nvcc  $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -x cu -c /home/nvidia/Documents/dbs/gpgpu/cudamodel/src/GPiNeuron.cu -o CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o

CMakeFiles/dbmain.dir/src/GPiNeuron.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/dbmain.dir/src/GPiNeuron.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/dbmain.dir/src/GPiNeuron.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/dbmain.dir/src/GPiNeuron.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o.requires:

.PHONY : CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o.requires

CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o.provides: CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o.requires
	$(MAKE) -f CMakeFiles/dbmain.dir/build.make CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o.provides.build
.PHONY : CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o.provides

CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o.provides.build: CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o


CMakeFiles/dbmain.dir/src/BGNetwork.cu.o: CMakeFiles/dbmain.dir/flags.make
CMakeFiles/dbmain.dir/src/BGNetwork.cu.o: src/BGNetwork.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/nvidia/Documents/dbs/gpgpu/cudamodel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CUDA object CMakeFiles/dbmain.dir/src/BGNetwork.cu.o"
	/usr/local/cuda-10.0/bin/nvcc  $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -x cu -c /home/nvidia/Documents/dbs/gpgpu/cudamodel/src/BGNetwork.cu -o CMakeFiles/dbmain.dir/src/BGNetwork.cu.o

CMakeFiles/dbmain.dir/src/BGNetwork.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/dbmain.dir/src/BGNetwork.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/dbmain.dir/src/BGNetwork.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/dbmain.dir/src/BGNetwork.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

CMakeFiles/dbmain.dir/src/BGNetwork.cu.o.requires:

.PHONY : CMakeFiles/dbmain.dir/src/BGNetwork.cu.o.requires

CMakeFiles/dbmain.dir/src/BGNetwork.cu.o.provides: CMakeFiles/dbmain.dir/src/BGNetwork.cu.o.requires
	$(MAKE) -f CMakeFiles/dbmain.dir/build.make CMakeFiles/dbmain.dir/src/BGNetwork.cu.o.provides.build
.PHONY : CMakeFiles/dbmain.dir/src/BGNetwork.cu.o.provides

CMakeFiles/dbmain.dir/src/BGNetwork.cu.o.provides.build: CMakeFiles/dbmain.dir/src/BGNetwork.cu.o


# Object files for target dbmain
dbmain_OBJECTS = \
"CMakeFiles/dbmain.dir/main.cu.o" \
"CMakeFiles/dbmain.dir/src/gating.cu.o" \
"CMakeFiles/dbmain.dir/src/THNeuron.cu.o" \
"CMakeFiles/dbmain.dir/src/STNNeuron.cu.o" \
"CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o" \
"CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o" \
"CMakeFiles/dbmain.dir/src/BGNetwork.cu.o"

# External object files for target dbmain
dbmain_EXTERNAL_OBJECTS =

CMakeFiles/dbmain.dir/cmake_device_link.o: CMakeFiles/dbmain.dir/main.cu.o
CMakeFiles/dbmain.dir/cmake_device_link.o: CMakeFiles/dbmain.dir/src/gating.cu.o
CMakeFiles/dbmain.dir/cmake_device_link.o: CMakeFiles/dbmain.dir/src/THNeuron.cu.o
CMakeFiles/dbmain.dir/cmake_device_link.o: CMakeFiles/dbmain.dir/src/STNNeuron.cu.o
CMakeFiles/dbmain.dir/cmake_device_link.o: CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o
CMakeFiles/dbmain.dir/cmake_device_link.o: CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o
CMakeFiles/dbmain.dir/cmake_device_link.o: CMakeFiles/dbmain.dir/src/BGNetwork.cu.o
CMakeFiles/dbmain.dir/cmake_device_link.o: CMakeFiles/dbmain.dir/build.make
CMakeFiles/dbmain.dir/cmake_device_link.o: CMakeFiles/dbmain.dir/dlink.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/nvidia/Documents/dbs/gpgpu/cudamodel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Linking CUDA device code CMakeFiles/dbmain.dir/cmake_device_link.o"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/dbmain.dir/dlink.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/dbmain.dir/build: CMakeFiles/dbmain.dir/cmake_device_link.o

.PHONY : CMakeFiles/dbmain.dir/build

# Object files for target dbmain
dbmain_OBJECTS = \
"CMakeFiles/dbmain.dir/main.cu.o" \
"CMakeFiles/dbmain.dir/src/gating.cu.o" \
"CMakeFiles/dbmain.dir/src/THNeuron.cu.o" \
"CMakeFiles/dbmain.dir/src/STNNeuron.cu.o" \
"CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o" \
"CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o" \
"CMakeFiles/dbmain.dir/src/BGNetwork.cu.o"

# External object files for target dbmain
dbmain_EXTERNAL_OBJECTS =

dbmain: CMakeFiles/dbmain.dir/main.cu.o
dbmain: CMakeFiles/dbmain.dir/src/gating.cu.o
dbmain: CMakeFiles/dbmain.dir/src/THNeuron.cu.o
dbmain: CMakeFiles/dbmain.dir/src/STNNeuron.cu.o
dbmain: CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o
dbmain: CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o
dbmain: CMakeFiles/dbmain.dir/src/BGNetwork.cu.o
dbmain: CMakeFiles/dbmain.dir/build.make
dbmain: CMakeFiles/dbmain.dir/cmake_device_link.o
dbmain: CMakeFiles/dbmain.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/nvidia/Documents/dbs/gpgpu/cudamodel/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Linking CUDA executable dbmain"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/dbmain.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/dbmain.dir/build: dbmain

.PHONY : CMakeFiles/dbmain.dir/build

CMakeFiles/dbmain.dir/requires: CMakeFiles/dbmain.dir/main.cu.o.requires
CMakeFiles/dbmain.dir/requires: CMakeFiles/dbmain.dir/src/gating.cu.o.requires
CMakeFiles/dbmain.dir/requires: CMakeFiles/dbmain.dir/src/THNeuron.cu.o.requires
CMakeFiles/dbmain.dir/requires: CMakeFiles/dbmain.dir/src/STNNeuron.cu.o.requires
CMakeFiles/dbmain.dir/requires: CMakeFiles/dbmain.dir/src/GPeNeuron.cu.o.requires
CMakeFiles/dbmain.dir/requires: CMakeFiles/dbmain.dir/src/GPiNeuron.cu.o.requires
CMakeFiles/dbmain.dir/requires: CMakeFiles/dbmain.dir/src/BGNetwork.cu.o.requires

.PHONY : CMakeFiles/dbmain.dir/requires

CMakeFiles/dbmain.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/dbmain.dir/cmake_clean.cmake
.PHONY : CMakeFiles/dbmain.dir/clean

CMakeFiles/dbmain.dir/depend:
	cd /home/nvidia/Documents/dbs/gpgpu/cudamodel && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/nvidia/Documents/dbs/gpgpu/cudamodel /home/nvidia/Documents/dbs/gpgpu/cudamodel /home/nvidia/Documents/dbs/gpgpu/cudamodel /home/nvidia/Documents/dbs/gpgpu/cudamodel /home/nvidia/Documents/dbs/gpgpu/cudamodel/CMakeFiles/dbmain.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/dbmain.dir/depend

