//
// Created by Jasmine Lu on 2019-04-27.
//

#include "GPiNeuron.h"
#include "Neuron.h"
#include "gating.h"
#include <string>
#include <iostream>
#include <math.h>

GPiNeuron::GPiNeuron(double dt, double duration, double start_voltage, std::map<std::string, double>* parameters):Neuron(dt, duration, start_voltage, parameters){
    initialize_gating_variables();
};

void GPiNeuron::compute_currents() {
    std::map<std::string, double> &c = *currents;
    std::map<std::string, double> &p = *parameters;
    double v = (*voltage)[dt_index - 1];

    c["I_L"] = -(p["g_L"] * (v - p["E_L"]));
    c["I_Na"] = -(p["g_Na"] * (pow(gpe_minf(v), 3)) * h_gate * (v - p["E_Na"]));
    c["I_K"] = -(p["g_K"] * pow(n_gate, 4) * (v - p["E_K"]));
    c["I_T"] = -(p["g_T"] * pow(gpe_ainf(v), 3) * r_gate * (v - p["E_T"]));
    c["I_Ca"] = -(p["g_Ca"] * pow(gpe_sinf(v), 3) * (v - p["E_Ca"]));
    c["I_ahp"] = -(p["g_ahp"] * (v - p["E_ahp"]) * (CA/(CA + 10)));

    std::cout << "Voltage: " << v << std::endl;
    std::cout << "H: " << h_gate << std::endl;
    std::cout << "R: " << r_gate << std::endl;
    std::cout << "Current I_L: " << c["I_L"] << std::endl;
    std::cout << "Current I_Na: " << c["I_Na"] << std::endl;
    std::cout << "Current I_K: " << c["I_K"] << std::endl;
    std::cout << "Current I_T: " << c["I_T"] << std::endl;
    std::cout << "Current I_Ca: " << c["I_Ca"] << std::endl;
    std::cout << "Current I_ahp: " << c["I_ahp"] << std::endl;
    std::cout << std::endl;
}

void GPeNeuron::compute_gating_variables() {
    std::map<std::string, double> &c = *currents;

    double v = (*voltage)[dt_index-1];
    h_gate = h_gate + dt * 0.75 * ((gpe_hinf(v) - h_gate)/gpe_tauh(v));
    r_gate = r_gate + dt * 0.2 * (gpe_rinf(v) - r_gate)/30;
    n_gate = n_gate + dt * 0.75 * (gpe_ninf(v) - n_gate)/gpe_taun(v);
    CA = CA + dt * pow(10, -4) * (-(c["I_Ca"]) - c["I_T"] - (15 * CA));
}

void GPeNeuron::initialize_gating_variables() {
    double v = (*voltage)[dt_index-1];
    h_gate = gpe_hinf(v);
    r_gate = gpe_rinf(v);
    n_gate = gpe_ninf(v);
    CA = 0.1;
    // Write in other currents
}
