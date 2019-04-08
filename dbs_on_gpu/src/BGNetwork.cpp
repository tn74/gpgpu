//
// Created by Trishul Nagenalli on 2019-04-04.
//

#include "BGNetwork.h"
#include <iostream>


BGNetwork::BGNetwork(){
    std::cout << "BGNetwork Constructor" << std::endl;
    network_parameters = new std::map<std::string, std::map<std::string, double>* >();
    all_cells = new std::map<std::string, std::vector<Neuron*>* >();
    dt = 0.00001;
    duration = 1;
    build_parameter_map();
    std::cout << "Finished Parameter Map" << std::endl;

    initialize_cells();
}

void BGNetwork::build_parameter_map() {
    std::cout << "Starting parameter map" << std::endl;
    (*network_parameters)["th"] = new std::map<std::string, double>();
    std::cout << (*network_parameters)["th"] << (*network_parameters)["th"] << std::endl;
    std::map<std::string, double>* th_param_ptr = (*network_parameters)["th"];
    std::map<std::string, double> &th_param = *th_param_ptr;

    th_param["C_m"] = 1.0;
    th_param["g_L"] = 0.05;
    th_param["E_L"] = -70;
    th_param["g_Na"] = 3.0;
    th_param["E_Na"] = 50.0;
    th_param["g_K"] = 5.0;
    th_param["E_K"] = -75.0;
    th_param["g_T"] = 5.0;
    th_param["E_T"] = 0.0;
//    std::cout << "g_L = " << (*th_param_ptr)["g_L"]  << std::endl;
//    std::cout << "th_params: "  << &th_param << ", th_params_ptr: " << th_param_ptr << " " << &(*th_param_ptr) << std::endl;
//    std::cout << "Built Parameter Map" << std::endl;
//    std::cout << "Size = " << (*network_parameters)["th"]->size() << std::endl;
}

void BGNetwork::initialize_cells() {
    std::cout << "Start Initialized Cells" << std::endl;
    (*all_cells)["th"] = new std::vector<Neuron*>();
    (*all_cells)["th"]->reserve(20);
    (*all_cells)["th"]->push_back(new THNeuron(dt, duration, -62.0, (*network_parameters)["th"]));
    std::cout << "Initialized Cell" << std::endl;

}

int BGNetwork::simulate() {
    auto iterations = (unsigned long) (duration/dt);
    for (int round = 0; round < iterations; ++round){
//        std::cout << "Round" << round << "\n";
        for (auto&& [cell_type, cells]: *all_cells) {
            for (auto&& n: *cells) {
                n->advance_time_step();
            }
        }
    }
    return 0;
};

std::map<std::string, std::vector<std::vector<double>>> BGNetwork::get_voltages() {
//    std::map<std::string, std::vector<std::vector<double>>> voltages = new std::map<std::string, std::vector<std::vector<double>>>();
//    for(auto cell_type = all_cells.begin(); iter != all_cells.end(); ++iter)
//    {
//        std::vector<Neuron> neurons = cell_type->second;
//        for (int i = 0; i < neurons.size(); ++i){
//
//        }
//    }
}

