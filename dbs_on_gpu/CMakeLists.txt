cmake_minimum_required(VERSION 3.13)
project(dbs_on_gpu)

set(CMAKE_CXX_STANDARD 14)

add_executable(GPUImplementation
        main.cpp
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
        src/BGNetwork.h)