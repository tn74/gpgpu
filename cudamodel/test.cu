#include <iostream>
#include "src/BGNetwork.h"
#include "dbs.cu"

extern "C" int test_run() { 
    auto sim_params = (simulation_parameters_t *) malloc(sizeof(simulation_parameters));
    sim_params->cells_per_type = 10;
    sim_params->duration = 1;
    sim_params->dt = 0.01;
    return execute_simulation(sim_params);
}

