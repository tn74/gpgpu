#include <iostream>

#include "src/gating.h"
#include "src/BGNetwork.h"

//struct TH_PARAM {
//    double c_m;
//    TH_PARAM() {
//        c_m=109;
//    }
//};
//
////__global__ void func(int* num_array) {
////    num_array[threadIdx.x] = threadIdx.x;
////    return;
////}
//
//void struct_test() {
////    auto* s = (th_param_t*) malloc(sizeof(th_param));
////    cudaMallocManaged(&s, sizeof(th_param));
////    initialize_th_param(s);
////    std::cout << s->C_m << std::endl;
//}


int main() {
    auto sim_params = (simulation_parameters_t*) malloc(sizeof(simulation_parameters));
    sim_params->cells_per_type = 1;
    sim_params->duration = 10;
    sim_params->dt=0.01;
    auto net = BGNetwork(sim_params);
    net.simulate();
    return 0;


//    int* num_ptr = (int*) malloc(255 * sizeof(int));
//    std::cout << *num_ptr << std::endl;
////    func <<<1,  32>>> (num_ptr);
//    std::cout << *num_ptr << std::endl;
//    return 0;
}