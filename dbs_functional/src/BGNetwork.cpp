//
// Created by Trishul Nagenalli on 2019-04-04.
//

#include "BGNetwork.h"
#include <iostream>
#include "parameter_structs.h"
#include "THNeuron.h"


BGNetwork::BGNetwork(int n, double dur, double delta){
    std::cout << "BGNetwork Constructor" << std::endl;
    dt_index = 0;
    dt = delta;
    duration = dur;
    number_of_cells = n;
    all_cells = new std::map<int, std::vector<Neuron*>* >();

    compute_mem = (compute_memory_t*) malloc(sizeof(compute_memory_t));
    compute_mem -> network_parameters = (param*) malloc(sizeof(param_t));
    build_parameter_map();
    initialize_cells();
}

void BGNetwork::build_parameter_map() {
    compute_mem -> network_parameters -> th = (th_param_t*) malloc(sizeof(th_param));
    initialize_parameter_map(compute_mem -> network_parameters);
}

void BGNetwork::initialize_cells() {
    std::cout << "Start Initialized Cells" << std::endl;
    (*all_cells)[0] = new std::vector<Neuron*>();
    (*all_cells)[0]->reserve(number_of_cells);
    for (int i = 0 ; i < number_of_cells; ++i) {
        (*all_cells)[0]->push_back(new THNeuron(dt, duration, -57.0, compute_mem -> network_parameters, i));
    }
    std::cout << "Initialized Cell" << std::endl;


}

void BGNetwork::advance_time_step() {
    for (int i = 0; i < (*all_cells)[0]->size(); ++i) {
        double v = ((*all_cells)[0]->at(i))->voltage->back();
        th_compute_currents(v, *compute_mem, i);
    }
}

int BGNetwork::simulate() {
    for (auto&& [cell_type, cells]: *all_cells) {
        for (auto&& n: *cells) {
            advance_time_step();
        }
    }
    return 0;
};
