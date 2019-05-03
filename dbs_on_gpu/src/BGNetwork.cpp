//
// Created by Trishul Nagenalli on 2019-04-04.
//

#include "BGNetwork.h"
#include <iostream>


BGNetwork::BGNetwork(int n, double dur, double delta){
    std::cout << "BGNetwork Constructor" << std::endl;
    network_parameters = new std::map<std::string, std::map<std::string, double>* >();
    all_cells = new std::map<std::string, std::vector<Neuron*>* >();
    dt = delta;
    duration = dur;
    NUMBER_OF_CELLS = n;
    build_parameter_map();
    std::cout << "Finished Parameter Map" << std::endl;

    initialize_cells();
}

void BGNetwork::build_parameter_map() {
    std::cout << "Starting parameter map" << std::endl;

    //TH NEURON
    (*network_parameters)["TH"] = new std::map<std::string, double>();
    std::cout << (*network_parameters)["TH"] << (*network_parameters)["TH"] << std::endl;
    std::map<std::string, double>* th_param_ptr = (*network_parameters)["TH"];
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

    //STN NEURON
    (*network_parameters)["STN"] = new std::map<std::string, double>();
    std::cout << (*network_parameters)["STN"] << (*network_parameters)["STN"] << std::endl;
    std::map<std::string, double>* stn_param_ptr = (*network_parameters)["STN"];
    std::map<std::string, double> &stn_param = *stn_param_ptr;

    stn_param["C_m"] = 1.0;
    stn_param["g_L"] = 2.25;
    stn_param["E_L"] = -60.0;
    stn_param["g_Na"] = 37.0;
    stn_param["E_Na"] = 55.0;
    stn_param["g_K"] = 45.0;
    stn_param["E_K"] = -80.0;
    stn_param["g_T"] = 0.5;
    stn_param["E_T"] = 0.0;
    stn_param["g_Ca"] = 2.0;
    stn_param["E_Ca"] = 140.0;
    stn_param["g_ahp"] = 20.0;
    stn_param["E_ahp"] = -80.0;

    //GPe Neuron
    (*network_parameters)["GPE"] = new std::map<std::string, double>();
    std::cout << (*network_parameters)["GPE"] << (*network_parameters)["GPE"] << std::endl;
    std::map<std::string, double>* gpe_param_ptr = (*network_parameters)["GPE"];
    std::map<std::string, double> &gpe_param = *gpe_param_ptr;

    gpe_param["C_m"] = 1.0;
    gpe_param["g_L"] = 0.1;
    gpe_param["E_L"] = -65.0;
    gpe_param["g_Na"] = 120.0;
    gpe_param["E_Na"] = 55.0;
    gpe_param["g_K"] = 30.0;
    gpe_param["E_K"] = -80.0;
    gpe_param["g_T"] = 0.5;
    gpe_param["E_T"] = 0.0;
    gpe_param["g_Ca"] = 0.15;
    gpe_param["E_Ca"] = 120.0;
    gpe_param["g_ahp"] = 10.0;
    gpe_param["E_ahp"] = -80.0;

    //GPi Neuron
    (*network_parameters)["GPI"] = new std::map<std::string, double>();
    std::cout << (*network_parameters)["GPI"] << (*network_parameters)["GPI"] << std::endl;
    std::map<std::string, double>* gpi_param_ptr = (*network_parameters)["GPI"];
    std::map<std::string, double> &gpi_param = *gpi_param_ptr;

    gpi_param["C_m"] = 1.0;
    gpi_param["g_L"] = 0.1;
    gpi_param["E_L"] = -65.0;
    gpi_param["g_Na"] = 120.0;
    gpi_param["E_Na"] = 55.0;
    gpi_param["g_K"] = 30.0;
    gpi_param["E_K"] = -80.0;
    gpi_param["g_T"] = 0.5;
    gpi_param["E_T"] = 0.0;
    gpi_param["g_Ca"] = 0.15;
    gpi_param["E_Ca"] = 120.0;
    gpi_param["g_ahp"] = 10.0;
    gpi_param["E_ahp"] = -80.0;
//    std::cout << "g_L = " << (*th_param_ptr)["g_L"]  << std::endl;
//    std::cout << "th_params: "  << &th_param << ", th_params_ptr: " << th_param_ptr << " " << &(*th_param_ptr) << std::endl;
//    std::cout << "Built Parameter Map" << std::endl;
//    std::cout << "Size = " << (*network_parameters)["th"]->size() << std::endl;
}

void BGNetwork::initialize_cells() {
    std::cout << "Start Initialized Cells" << std::endl;
    (*all_cells)["TH"] = new std::vector<Neuron*>();
    (*all_cells)["TH"]->reserve(NUMBER_OF_CELLS);
    for (int i = 0 ; i < NUMBER_OF_CELLS; ++i) {
        (*all_cells)["TH"]->push_back(new THNeuron(dt, duration, -57.0, (*network_parameters)["TH"], i));
    }

    (*all_cells)["STN"] = new std::vector<Neuron*>();
    (*all_cells)["STN"]->reserve(NUMBER_OF_CELLS);
    for (int i = 0 ; i < NUMBER_OF_CELLS; ++i) {
        (*all_cells)["STN"]->push_back(new STNNeuron(dt, duration, -57.0, (*network_parameters)["STN"], i));
    }

    (*all_cells)["GPE"] = new std::vector<Neuron*>();
    (*all_cells)["GPE"]->reserve(NUMBER_OF_CELLS);
    for (int i = 0 ; i < NUMBER_OF_CELLS; ++i) {
        (*all_cells)["GPE"]->push_back(new GPeNeuron(dt, duration, -57.0, (*network_parameters)["GPE"], i));
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
    n-> debug();
    for (int round = 0; round < iterations - 1; ++round){
        n->advance_time_step();
        n->debug();
        // SYNCHRONIZE WITH OTHER CELLS
    }
}
