cmake_minimum_required(VERSION 3.13)

project(dbs_on_gpu)
# LANGUAGES CXX CUDA
set(CMAKE_CXX_STANDARD 17)
set(c_SOURCES main.cpp
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

add_executable(GPUImplementation ${c_SOURCES})
# https://stackoverflow.com/questions/45793407/compiling-adding-cuda-code-to-existing-project-cmake
# find_package(CUDA QUIET)
# the above supplies the below boolean
# if(CUDA_FOUND)
#     include_directories(${CUDA_INCLUDE_DIRS})
#     SET(ALL_CUDA_LIBS ${CUDA_LIBRARIES} ${CUDA_cusparse_LIBRARY} ${CUDA_cublas_LIBRARY})
#     SET(LIBS ${LIBS} ${ALL_CUDA_LIBS})
#     message(STATUS "CUDA_LIBRARIES: ${CUDA_INCLUDE_DIRS} ${ALL_CUDA_LIBS}")
#     set(CUDA_PROPAGATE_HOST_FLAGS ON)
#     set(CUDA_SEPARABLE_COMPILATION OFF)
#     list( APPEND CUDA_NVCC_FLAGS -gencode=arch=compute_30,code=compute_30 )
#     list( APPEND CUDA_NVCC_FLAGS -gencode=arch=compute_52,code=sm_52 )
# endif()