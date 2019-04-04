//
// Created by Trishul Nagenalli on 2019-04-04.
//

#include "BGNetwork.h"

BGNetwork::BGNetwork(){
    build_parameter_map();
    initialize_cells();
}

void BGNetwork::build_parameter_map() {
    std::map<std::string, double> th_params;
    th_params["C_m"] = 1.0;
    th_params["g_L"] = 0.05;
    th_params["E_L"] = -70;
    th_params["g_Na"] = 3.0;
    th_params["E_Na"] = 50.0;
    th_params["g_k"] = 5.0;
    th_params["E_k"] = -75.0;
    th_params["g_T"] = 5.0;
    th_params["E_T"] = 0.0;
    network_parameters["th"] = th_params;
}

void BGNetwork::initialize_cells() {
    all_cells["th"][0] = THNeuron(dt, duration, 0.05, network_parameters["th"]);

}

int BGNetwork::simulate() {
    auto iterations = (unsigned long) (duration/dt);
    for (int round = 0; round < iterations; ++round){
        for (auto&& [cell_type, cells]: all_cells) {
            for (auto&& n: cells) {
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

