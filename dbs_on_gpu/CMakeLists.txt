cmake_minimum_required(VERSION 3.13)
project(dbs_on_gpu)

set(CMAKE_CXX_STANDARD 14)

add_executable(GPUImplementation main.cpp src/Neuron.cpp src/Neuron.h src/THNeuron.cpp src/THNeuron.h src/BGNetwork.cpp src/BGNetwork.h)