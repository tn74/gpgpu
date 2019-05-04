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
        (*all_cells)["TH"]->push_back(new THNeuron(dt, duration, -57.0, network_parameters->th, i));
    }

//    (*all_cells)["STN"] = new std::vector<Neuron*>();
//    (*all_cells)["STN"]->reserve(number_of_cells);
//    for (int i = 0 ; i < number_of_cells; ++i) {
//        (*all_cells)["STN"]->push_back(new STNNeuron(dt, duration, -57.0, (*network_parameters)["STN"], i));
//    }
//
//    (*all_cells)["GPE"] = new std::vector<Neuron*>();
//    (*all_cells)["GPE"]->reserve(number_of_cells);
//    for (int i = 0 ; i < number_of_cells; ++i) {
//        (*all_cells)["GPE"]->push_back(new GPeNeuron(dt, duration, -57.0, (*network_parameters)["GPE"], i));
//    }
//
//    (*all_cells)["GPI"] = new std::vector<Neuron*>();
//    (*all_cells)["GPI"]->reserve(number_of_cells);
//    for (int i = 0 ; i < number_of_cells; ++i) {
//        (*all_cells)["GPI"]->push_back(new GPiNeuron(dt, duration, -57.0, (*network_parameters)["GPI"], i));
//    }

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
    n-> debug();
    for (int round = 0; round < iterations; ++round){
        n->advance_time_step();
        n->debug();
        // SYNCHRONIZE WITH OTHER CELLS
    }
}
