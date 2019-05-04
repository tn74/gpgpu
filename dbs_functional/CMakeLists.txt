cmake_minimum_required(VERSION 3.13)
set(CMAKE_CUDA_COMPILER /Developer/NVIDIA/CUDA-10.1/bin/nvcc)

project(dbs_functional LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
# LANGUAGES CXX CUDA

add_executable(
        dbs_functional
        main.cpp
        src/parameter_structs.h
        src/parameter_structs.cpp
        src/gating.cpp
        src/gating.h
        src/Neuron.cpp
        src/Neuron.h
        src/THNeuron.cpp
        src/THNeuron.h
        src/GPeNeuron.cpp
        src/GPeNeuron.h
        src/GPiNeuron.cpp
        src/GPiNeuron.h
        src/STNNeuron.cpp
        src/STNNeuron.h
        src/BGNetwork.cpp
        src/BGNetwork.h
)