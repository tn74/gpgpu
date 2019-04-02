//
// Created by Trishul Nagenalli on 2019-03-28.
//

#include "THNeuron.h"
#include "Neuron.h"
#include "gating.h"


void THNeuron::compute_currents() {
    std::map<std::string, double> p = this->parameters;
    this->currents["I_L"] = -parameters.at("g_L") * (voltage[dt_index - 1] - p.at("E_L"));
    // Write in other currents
}

void THNeuron::compute_gating_variables() {
    std::map<std::string, double> p = this->parameters;
    double v = voltage[dt_index-1];
    h_gate = h_gate + dt * (th_hinf(v) - h_gate)/th_tauh(v);

    // Write in other currents
}
