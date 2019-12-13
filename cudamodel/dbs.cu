//
// Created by Trishul Nagenalli on 2019-11-21.
//

#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include "src/THNeuron.h"
#include "src/BGNetwork.h"


extern "C" int  execute_simulation(simulation_parameters_t* sim_params) {
    auto net = BGNetwork(sim_params);
    net.simulate();
    std::cout << "Simulation Duration: " << sim_params->duration << std::endl;
    return 0;
}

extern "C" int  execute_simulation_debug(simulation_parameters_t* sim_params) {
    auto net = BGNetwork(sim_params);
    net.simulate_debug();
    std::cout << "Simulation Duration: " << sim_params->duration << std::endl;
    return 0; 
}
