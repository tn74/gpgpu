#include <iostream>

struct TH_PARAM {
    double c_m;
    TH_PARAM() {
        c_m=109;
    }
};

__global__ void func(int* num_ptr) {
    int &num = *num_ptr;
    num = num + 1;
    return;
}


int main() {
    int* num_ptr = (int*) malloc(sizeof(int));
    (*num_ptr) = 10;
    std::cout << *num_ptr << std::endl;
    func <<<1,  32>>> (num_ptr);
    std::cout << *num_ptr << std::endl;
    return 0;
}