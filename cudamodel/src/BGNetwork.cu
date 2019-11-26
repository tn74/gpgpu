//
// Created by Trishul Nagenalli on 2019-04-04.
//

#include <iostream>
#include <string>
#include <sstream>
#include <fstream>

#include "BGNetwork.h"
#include "THNeuron.h"


BGNetwork::BGNetwork(simulation_parameters_t* sp){
    std::cout << "BGNetwork Constructor" << std::endl;
    sim_params = sp;
    dt_index = 0;
    state_start = (th_state_t*) (malloc(sp->cells_per_type * sizeof(th_state)));
    state_end = (th_state_t*) (malloc(sp->cells_per_type * sizeof(th_state)));
    build_parameter_map();
    initialize_cells();
}

void BGNetwork::build_parameter_map() {
    th_params = (th_param_t*) malloc(sizeof(th_param));
    th_params -> C_m = 1.0;
    th_params -> g_L = 0.05;
    th_params -> E_L = -70;
    th_params -> g_Na = 3.0;
    th_params -> E_Na = 50.0;
    th_params -> g_K = 5.0;
    th_params -> E_K = -75.0;
    th_params -> g_T = 5.0;
    th_params -> E_T = 0.0;
    std::cout << "Built Parameter Map" << std::endl;
}

void BGNetwork::initialize_cells() {
    for (int i = 0; i < sim_params-> cells_per_type; ++i) {
        init_state(&state_start[i]);
    }
}

void BGNetwork::advance_time_step() {
    for (int i = 0; i < (sim_params-> cells_per_type); ++i) {
        compute_next_state<<<1, 16>>>(&state_start[i], &state_end[i], th_params, sim_params->dt);
    }
    dt_index ++;
    th_state_t* tmp = state_start;
    state_start = state_end;
    state_end = tmp;
    std::cout << "\r"  << "Iteration: " << dt_index << std::endl;
}

void BGNetwork::debug(th_state_t* state) {
    for (int i = 0; i < sim_params->cells_per_type; ++i) {
        std::ostringstream output_file_name;
        output_file_name << "output/TH_NEURON_" << i << ".txt";
        std::ofstream out(output_file_name.str(), std::ios::app);
        out << "DT=" << dt_index << ", " << get_debug_string(&state[i]) << std::endl;
        out.close();
    }
}
int BGNetwork::simulate() {
    system("exec rm -r output/*");
    debug(state_start);
    for (int i = 0; i < sim_params->duration / sim_params->dt; ++i) {
        advance_time_step();
        debug(state_start);
    }
    return 0;
};
