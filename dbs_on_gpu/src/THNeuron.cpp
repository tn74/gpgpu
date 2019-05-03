//
// Created by Trishul Nagenalli on 2019-03-28.
//

#include "THNeuron.h"
#include "Neuron.h"
#include "gating.h"
#include <string>
#include <iostream>
#include <math.h>

THNeuron::THNeuron(
        double dt,
        double duration,
        double start_voltage,
        std::map<std::string, double>* parameters,
        int id
        ):Neuron(dt, duration, start_voltage, parameters){
    cell_identifier = new std::string("TH_NEURON_" + std::to_string(id));
};

void THNeuron::compute_currents() {
    std::map<std::string, double> &c = *currents;
    std::map<std::string, double> &p = *parameters;
    std::map<std::string, double> &g = *gating_variables;
    double v = (*voltage)[dt_index];

    c["I_L"] = -(p["g_L"] * (v - p["E_L"]));
    c["I_Na"] = -(p["g_Na"] * (pow(th_minf(v), 3)) * g["H"] * (v - p["E_Na"]));
    c["I_K"] = -(p["g_K"] * pow(0.75 *(1 - g["H"]), 4) * (v - p["E_K"])); // SAME AS MATLAB BUT DIFFERENT FROM PAPER
    c["I_T"] = -(p["g_T"] * pow(th_pinf(v), 2) * g["R"] * (v - p["E_T"]));

//    std::cout << "Voltage: " << v << std::endl;
//    std::cout << "H: " << h_gate << std::endl;
//    std::cout << "R: " << r_gate << std::endl;
//    std::cout << "Current I_L: " << c["I_L"] << std::endl;
//    std::cout << "Current I_Na: " << c["I_Na"] << std::endl;
//    std::cout << "Current I_K: " << c["I_K"] << std::endl;
//    std::cout << "Current I_T: " << c["I_T"] << std::endl;
//    std::cout << std::endl;
}

void THNeuron::compute_gating_variables() {
    std::map<std::string, double> &g = *gating_variables;
    double v = (*voltage)[dt_index];
    g["H"] = g["H"] + dt * (th_hinf(v) - h_gate)/th_tauh(v);
    g["R"] = g["R"] + dt * (th_hinf(v) - h_gate)/th_tauh(v);
//    h_gate = h_gate + dt * (th_hinf(v) - h_gate)/th_tauh(v);
//    r_gate = r_gate + dt * (th_rinf(v) - r_gate)/th_taur(v);
}

void THNeuron::initialize_gating_variables() {
    std::map<std::string, double> &g = *gating_variables;
    double v = (*voltage)[dt_index];
    g["H"] = th_hinf(v);
    g["R"] = th_rinf(v);
//    h_gate = th_hinf(v);
//    r_gate = th_rinf(v);
    // Write in other currents
}
