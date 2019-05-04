//
// Created by Trishul Nagenalli on 2019-03-28.
//

#include "THNeuron.h"
#include "Neuron.h"
#include "gating.h"
#include <string>
#include <iostream>
#include <math.h>

void compute_currents(double v, th_current_t* c, th_param_t* p) {
    c->I_L = 2;
}

void compute_gating(double v, th_gate_t* g, th_param_t* p) {
    g->H = 0;
}

THNeuron::THNeuron(
        double dt,
        double duration,
        double start_voltage,
        param_t* network_parameters,
        int id
        ):Neuron(dt, duration, start_voltage){
    cell_identifier = new std::string("TH_NEURON_" + std::to_string(id));
    cell_params = network_parameters -> th;
    gates = (th_gate_t*) malloc(sizeof(th_gate));
    currents = (th_current_t*) malloc(sizeof(th_current));
    initialize_gating_variables();
};


void THNeuron::initialize_gating_variables() {
    double v = (*voltage).back();
    gates-> H = th_hinf(v);
    std::cout << "Gates H" << std::endl;

    gates-> R = th_rinf(v);
}

int THNeuron::debug_write() {
    std::map<std::string, double> &map_c = *map_currents;
    std::map<std::string, double> &map_g = *map_gates;
    map_c["I_L"] = currents -> I_L;
    map_c["I_K"] = currents -> I_K;
    map_c["I_Na"] = currents -> I_Na;
    map_c["I_T"] = currents -> I_T;
    map_g["H"] = gates -> H;
    map_g["R"] = gates -> R;
}
