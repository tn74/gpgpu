//
// Created by Trishul Nagenalli on 2019-03-28.
//

#include "THNeuron.h"
#include "Neuron.h"
#include "gating.h"
#include <string>
#include <iostream>

THNeuron::THNeuron(double dt, double duration, double start_voltage, std::map<std::string, double>* parameters):Neuron(dt, duration, start_voltage, parameters){
};

void THNeuron::compute_currents() {
    std::map<std::string, double> c = *currents;
    std::map<std::string, double> p = *parameters;
    std::vector<double> v = *voltage;

    c["I_L"] = -p["g_L"] * v[dt_index - 1] - p["E_L"];
    std::cout << "I_L = " << c["I_L"] << std::endl;
    std::cout << "g_L = " << p["g_L"] << std::endl;
    // Write in other currents
}

void THNeuron::compute_gating_variables() {
    std::map<std::string, double> p = *parameters;
    double v = (*voltage)[dt_index-1];
    h_gate = h_gate + dt * (th_hinf(v) - h_gate)/th_tauh(v);

    // Write in other currents
}
