//
// Created by Trishul Nagenalli on 2019-11-21.
//

#include "src/BGNetwork.h"


int add(int a, int b) {
    return a + b;
}

int plain() {
    return 1;
}

int execute_simulation(simulation_parameters_t* sim_params) {
    auto net = BGNetwork(sim_params);
    net.simulate();
    return 0;
}
