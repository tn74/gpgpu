#include <iostream>

//#include "src/gating.h"
#include "src/BGNetwork.h"
#include "dbs.cpp"

extern "C" int addnum(int a, int b) {
    return a + b;
}

extern "C" int plain2() {
    return 2;
}

extern "C" int main() {
    std::cout << plain() << std::endl;
    plain2();
    auto sim_params = (simulation_parameters_t *) malloc(sizeof(simulation_parameters));
    sim_params->cells_per_type = 1;
    sim_params->duration = 1;
    sim_params->dt = 0.01;
    return execute_simulation(sim_params);
}

