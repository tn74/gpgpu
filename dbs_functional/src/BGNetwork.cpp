//
// Created by Trishul Nagenalli on 2019-04-04.
//

#include <iostream>
#include "BGNetwork.h"
#include "THNeuron.h"


BGNetwork::BGNetwork(simulation_parameters_t* sp){
    std::cout << "BGNetwork Constructor" << std::endl;
    sim_params = sp;
    dt_index = 0;
    state_array = (th_state_t*) (malloc(sp->cells_per_type * sizeof(th_state)));
    state_array_1 = (th_state_t*) (malloc(sp->cells_per_type * sizeof(th_state)));
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
        th_init_state(&state_array[i]);
    }
}

void BGNetwork::advance_time_step() {
    for (int i = 0; i < (sim_params-> cells_per_type); ++i) {
        if (dt_index % 2 == 1) {
            th_compute_next_state(&state_array[i], &state_array_1[i], th_params, sim_params->dt);
        } else {
            th_compute_next_state(&state_array_1[i], &state_array[i], th_params, sim_params->dt);
        }
    }
    dt_index ++;
    std::cout << dt_index << std::endl;
}

int BGNetwork::simulate() {
    advance_time_step();
    return 0;
};
