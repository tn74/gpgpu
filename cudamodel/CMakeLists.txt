cmake_minimum_required(VERSION 3.13)
#set(CMAKE_CUDA_COMPILER /Developer/NVIDIA/CUDA-10.1/bin/nvcc)

project(dbs_functional LANGUAGES CXX)
#project(dbs_functional LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
#set(CMAKE_BUILD_TYPE Debug)
#set(CMAKE_BUILD_TYPE RelWithDebInfo)

# LANGUAGES CXX CUDA

add_executable(
        dbs_functional
        main.cpp
        src/gating.cpp
        src/gating.h
        src/THNeuron.cpp
        src/THNeuron.h
        src/BGNetwork.cpp
        src/BGNetwork.h
)