//
// Created by Trishul Nagenalli on 2019-04-04.
//

#include "BGNetwork.h"
#include <iostream>
#include "parameter_structs.h"


BGNetwork::BGNetwork(int n, double dur, double delta){
    std::cout << "BGNetwork Constructor" << std::endl;
    all_cells = new std::map<std::string, std::vector<Neuron*>* >();
    dt = delta;
    duration = dur;
    number_of_cells = n;
    network_parameters = (param_t*) malloc(sizeof(param_t));
    build_parameter_map();
    std::cout << "Finished Parameter Map" << std::endl;
    initialize_cells();
}

void BGNetwork::build_parameter_map() {
    network_parameters -> th = (th_param*) malloc(sizeof(th_param));
    initialize_parameter_map(network_parameters);
}

void BGNetwork::initialize_cells() {
    std::cout << "Start Initialized Cells" << std::endl;
    (*all_cells)["TH"] = new std::vector<Neuron*>();
    (*all_cells)["TH"]->reserve(number_of_cells);
    for (int i = 0 ; i < number_of_cells; ++i) {
        (*all_cells)["TH"]->push_back(new THNeuron(dt, duration, -57.0, network_parameters, i));
    }

    std::cout << "Initialized Cell" << std::endl;

}

int BGNetwork::simulate() {
    for (auto&& [cell_type, cells]: *all_cells) {
        for (auto&& n: *cells) {
            run_cell_thread(n);
        }
    }
    return 0;
};

void BGNetwork::run_cell_thread(Neuron* n) {
    auto iterations = (unsigned long) (duration/dt);
    n->debug_write();
    for (int round = 0; round < iterations; ++round) {
        n->debug_write();
        // SYNCHRONIZE WITH OTHER CELLS
    }
}
