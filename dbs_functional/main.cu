#include <iostream>
#include "src/parameter_structs.h"

struct TH_PARAM {
    double c_m;
    TH_PARAM() {
        c_m=109;
    }
};

__global__ void func(int* num_array) {
    num_array[threadIdx.x] = threadIdx.x;
    return;
}

void struct_test() {
    th_param_t* s;
    cudaMallocManaged(&s, sizeof(th_param));
    initialize_th_param(s);
    std::cout << s->c_m << std::endl;
}


int main() {
    struct_test();
    int* num_ptr = (int*) malloc(255 * sizeof(int));
    std::cout << *num_ptr << std::endl;
//    func <<<1,  32>>> (num_ptr);
    std::cout << *num_ptr << std::endl;
    return 0;
}