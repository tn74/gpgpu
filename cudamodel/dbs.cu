//
// Created by Trishul Nagenalli on 2019-11-21.
//

#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include "src/THNeuron.h"
#include "src/BGNetwork.h"


extern "C"  int execute_simulation(simulation_parameters_t* sim_params) {
    auto net = BGNetwork(sim_params);
    net.simulate();
    return 0;
}

/*
__global__
void compute_preceeding(int* arr, int* sumarr, int maxlen) {
    int maxind = 64 * blockIdx.x + threadIdx.x;
    if (maxind >= maxlen) {
        return;
    }
    sumarr[maxind] = 0;
    for (int i = 0; i < maxind; ++i) {
        sumarr[maxind] += arr[i];
    } 
}

extern "C" int cudatest() {
    int arrlen = 90000;
    int* arr = (int*) malloc(sizeof(int) * arrlen);
    int* sumarr = (int*) malloc(sizeof(int) * arrlen); 
    cudaMallocManaged(&arr, arrlen*sizeof(int));
    cudaMallocManaged(&sumarr, arrlen*sizeof(int));
    for (int i = 0; i < arrlen; ++i) {
        arr[i] = i;   
        sumarr[i] = 0;
    }
    for (int i = 0; i < arrlen; ++i) {
        std::cout << sumarr[i] << " ";    
    }
    std::cout << std::endl;
    std::cout << "Past Init" << std::endl;
    //compute_preceeding<<<arrlen/64 + 1, 64>>>(arr, sumarr, arrlen);
    
    for (int tix = 0; tix < arrlen; ++tix) {
        for (int i = 0; i < tix; ++i) {
            sumarr[tix] += arr[i];
        }
    }
    
    std::cout << "Past Trap" << std::endl;
    cudaDeviceSynchronize();
    for (int i = 0; i < arrlen; ++i) {
        std::cout << sumarr[i] << " ";    
    }
    std::cout << std::endl;
    return 0;
}

extern "C" int plain() {
    return 1;
}

extern "C" int arrsum(int* arr, int arrlen) {
    int s = 0;
    for (int i = 0; i < arrlen; ++i) {
        s += arr[i];
    }
    return s;
}

extern "C" int addnum(int a, int b) {
    return a + b;
}

extern "C" int plain2() {
    return 2;
}

extern "C"  int execute_simulation(simulation_parameters_t* sim_params) {
    auto net = BGNetwork(sim_params);
    net.simulate();
    return 0;
}
*/
