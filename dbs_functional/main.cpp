#include <iostream>

#include "src/gating.h"
#include "src/BGNetwork.h"

int execute_simulation(simulation_parameters_t* sim_params) {
    auto net = BGNetwork(sim_params);
    return net.simulate();
}

int main() {
    auto sim_params = (simulation_parameters_t *) malloc(sizeof(simulation_parameters));
    sim_params->cells_per_type = 1;
    sim_params->duration = 10;
    sim_params->dt = 0.01;
    return execute_simulation(sim_params);
}

