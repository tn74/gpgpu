#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include "src/THNeuron.h"
#include "src/BGNetwork.h"
#include "dbs.cu"

int main() {
    auto sim_params = (simulation_parameters_t *) malloc(sizeof(simulation_parameters));
    sim_params->cells_per_type = 10;
    sim_params->duration = 1;
    sim_params->dt = 0.01;
    auto result =  execute_simulation_debug(sim_params);
    std::cout<< "End of main " << std::endl;
    return 0;
}

