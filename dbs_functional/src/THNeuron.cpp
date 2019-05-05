//
// Created by Trishul Nagenalli on 2019-03-28.
//

#include "THNeuron.h"
#include "Neuron.h"
#include "gating.h"
#include <string>
#include <iostream>
#include <math.h>
#include "BGNetwork.h"

void th_compute_currents(double v, compute_memory* compute, int cell_index) {
    auto c = compute->c_mat->th[cell_index];
    auto p = compute->network_parameters->th;
    auto g = compute->g_mat->th;
    c->I_Na = 0;
}

void th_compute_gating(double v, th_gate_t* g, th_param_t* p) {
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
    gates-> R = th_rinf(v);
}

int THNeuron::debug() {
    std::map<std::string, double> &map_c = *map_currents;
    std::map<std::string, double> &map_g = *map_gates;
    map_c["I_L"] = currents -> I_L;
    map_c["I_K"] = currents -> I_K;
    map_c["I_Na"] = currents -> I_Na;
    map_c["I_T"] = currents -> I_T;
    map_g["H"] = gates -> H;
    map_g["R"] = gates -> R;
    debug_write();
}
