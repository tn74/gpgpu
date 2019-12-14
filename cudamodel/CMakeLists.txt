cmake_minimum_required(VERSION 3.9)
set(CMAKE_CUDA_COMPILER /usr/local/cuda-10.0/bin/nvcc)

project(dbs LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} --relocatable-device-code true")

#set(CMAKE_BUILD_TYPE RelWithDebInfo)

# LANGUAGES CXX CUDA

set(CUDA_SEPARABLE_COMPILATION ON)


add_library(dbs MODULE
        dbs.cu
        src/gating.cu
        src/gating.h
        src/THNeuron.cu
        src/THNeuron.h
        src/STNNeuron.cu
        src/STNNeuron.h
        src/GPeNeuron.cu
        src/GPeNeuron.h
        src/GPiNeuron.cu
        src/GPiNeuron.h
        src/BGNetwork.cu
        src/BGNetwork.h
)
add_executable(
        dbsmain
        main.cu
        src/gating.cu
        src/gating.h
        src/THNeuron.cu
        src/THNeuron.h
        src/STNNeuron.cu
        src/STNNeuron.h
        src/GPeNeuron.cu
        src/GPeNeuron.h
        src/GPiNeuron.cu
        src/GPiNeuron.h
        src/BGNetwork.cu
        src/BGNetwork.h
)



