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
    initialize_gating_variables();
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
}

void THNeuron::compute_gating_variables() {
    std::map<std::string, double> &g = *gating_variables;
    double v = (*voltage)[dt_index];
    g["H"] = g["H"] + dt * (th_hinf(v) - g["H"])/th_tauh(v);
    g["R"] = g["R"] + dt * (th_rinf(v) - g["R"])/th_taur(v);
}

void THNeuron::initialize_gating_variables() {
    std::map<std::string, double> &g = *gating_variables;
    double v = (*voltage).back();
    g["H"] = th_hinf(v);
    g["R"] = th_rinf(v);
}
