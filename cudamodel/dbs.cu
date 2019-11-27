//
// Created by Trishul Nagenalli on 2019-11-21.
//

#include "src/BGNetwork.h"


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
