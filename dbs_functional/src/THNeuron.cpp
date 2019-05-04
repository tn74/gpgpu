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
        th_param_t* thp,
        int id
        ):Neuron(dt, duration, start_voltage, parameters){
    cell_identifier = new std::string("TH_NEURON_" + std::to_string(id));
    initialize_gating_variables();
};


void THNeuron::initialize_gating_variables() {
    std::map<std::string, double> &g = *gating_variables;
    double v = (*voltage).back();
    g["H"] = th_hinf(v);
    g["R"] = th_rinf(v);
}
