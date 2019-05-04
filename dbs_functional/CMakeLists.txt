cmake_minimum_required(VERSION 3.13)
set(CMAKE_CUDA_COMPILER /Developer/NVIDIA/CUDA-10.1/bin/nvcc)

project(dbs_functional LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
# LANGUAGES CXX CUDA

add_executable(
        dbs_functional
        main.cu
        src/gating.cu
        src/currents.cpp src/currents.h src/parameter_structs.h src/parameter_structs.cpp)