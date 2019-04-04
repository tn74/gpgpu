//
// Created by Trishul Nagenalli on 2019-03-28.
//

#include "THNeuron.h"
#include "Neuron.h"
#include "gating.h"
#include <string>
#include <iostream>
#include <math.h>

THNeuron::THNeuron(double dt, double duration, double start_voltage, std::map<std::string, double>* parameters):Neuron(dt, duration, start_voltage, parameters){
};

void THNeuron::compute_currents() {
    std::map<std::string, double> &c = *currents;
    std::map<std::string, double> &p = *parameters;
    double v = (*voltage)[dt_index - 1];

    c["I_L"] = -p["g_L"] * v - p["E_L"];
    c["I_Na"] = -p["g_NA"] * (pow(th_minf(v), 3)) * h_gate * (v - p["E_Na"]);
    c["I_K"] = -p["g_K"] * 0.75 *(1 - h_gate) * (v - p["E_K"]);
    c["I_T"] = -p["g_T"] * pow(th_pinf(v), 2) * r_gate * (v - p["E_T"]);

    std::cout << "Voltage: " << v << std::endl;
}

void THNeuron::compute_gating_variables() {
    std::map<std::string, double> p = *parameters;
    double v = (*voltage)[dt_index-1];
    h_gate = h_gate + dt * (th_hinf(v) - h_gate)/th_tauh(v);
    r_gate = r_gate + dt * (th_rinf(v) - r_gate)/th_taur(v);

    // Write in other currents
}
