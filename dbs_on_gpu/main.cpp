#include <iostream>
#include "src/Neuron.h"
#include "src/gating.h"
#include "src/BGNetwork.h"

int main() {
    std::cout << "Hello, World!" << std::endl;
//    std::cout << (th_hinf(3.0)) << std::endl;
    BGNetwork net = BGNetwork(1, 500, 0.01);
    net.simulate();
    return 0;
}
