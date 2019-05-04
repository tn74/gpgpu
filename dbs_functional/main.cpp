#include <iostream>

#include "src/parameter_structs.h"
#include "src/Neuron.h"
#include "src/gating.h"
#include "src/BGNetwork.h"

struct TH_PARAM {
    double c_m;
    TH_PARAM() {
        c_m=109;
    }
};

//__global__ void func(int* num_array) {
//    num_array[threadIdx.x] = threadIdx.x;
//    return;
//}

void struct_test() {
    auto* s = (th_param_t*) malloc(sizeof(th_param));
//    cudaMallocManaged(&s, sizeof(th_param));
    initialize_th_param(s);
    std::cout << s->C_m << std::endl;
}


int main() {
    struct_test();
    BGNetwork net = BGNetwork(1, 500, 0.01);
    net.simulate();
    return 0;


//    int* num_ptr = (int*) malloc(255 * sizeof(int));
//    std::cout << *num_ptr << std::endl;
////    func <<<1,  32>>> (num_ptr);
//    std::cout << *num_ptr << std::endl;
//    return 0;
}