#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include "src/THNeuron.h"
#include "src/BGNetwork.h"
#include "dbs.cu"


extern "C" double*** test_run() { 
    auto sim_params = (simulation_parameters_t *) malloc(sizeof(simulation_parameters));
    sim_params->cells_per_type = 10;
    sim_params->duration = 1;
    sim_params->dt = 0.01;
    return execute_simulation(sim_params);
}

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


