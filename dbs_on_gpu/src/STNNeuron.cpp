//
// Created by Jasmine Lu on 2019-04-27.
//

#include "STNNeuron.h"
#include "Neuron.h"
#include "gating.h"
#include <string>
#include <iostream>
#include <math.h>

STNNeuron::STNNeuron(
        double dt,
        double duration,
        double start_voltage,
        std::map<std::string,
        double>* parameters,
        int id
        ):Neuron(dt, duration, start_voltage, parameters){
    cell_identifier = new std::string("STN_NEURON_" + std::to_string(id));
    initialize_gating_variables();
};

void STNNeuron::compute_currents() {
    std::map<std::string, double> &c = *currents;
    std::map<std::string, double> &p = *parameters;
    std::map<std::string, double> &g = *gating_variables;

    double v = (*voltage)[dt_index];

    c["I_L"] = -(p["g_L"] * (v - p["E_L"]));
    c["I_Na"] = -(p["g_Na"] * (pow(stn_minf(v), 3)) * g["H"] * (v - p["E_Na"]));
    c["I_K"] = -(p["g_K"] * pow(g["N"], 4) * (v - p["E_K"]));
    c["I_T"] = -(p["g_T"] * pow(stn_ainf(v), 3) * pow(stn_binf(g["R"]), 2) * g["R"] * (v - p["E_T"]));
    c["I_Ca"] = -(p["g_Ca"] * pow(g["C"], 2) * (v - p["E_Ca"]));
    c["I_ahp"] = -(p["g_ahp"] * (v - p["E_ahp"]) * (g["CA"]/(g["CA"] + 15)));

}

void STNNeuron::compute_gating_variables() {
    std::map<std::string, double> &c = *currents;
    std::map<std::string, double> &g = *gating_variables;
    double v = (*voltage)[dt_index];
    g["H"] = g["H"] + dt * 0.75 * ((stn_hinf(v) - g["H"])/stn_tauh(v));
    g["R"] = g["R"] + dt * 0.2 * (stn_rinf(v) - g["R"])/stn_taur(v);
    g["N"] = g["N"] + dt * 0.75 * (stn_ninf(v) - g["N"])/stn_taun(v);
    g["C"] = g["C"] + dt * 0.08 * (stn_cinf(v) - g["C"])/stn_tauc(v);
    g["CA"] = g["CA"] + dt * 3.75 * pow(10, -5) * (-(c["I_Ca"]) - c["I_T"] - (22.5 * g["CA"]));
}

void STNNeuron::initialize_gating_variables() {
    double v = (*voltage)[dt_index];
    std::map<std::string, double> &g = *gating_variables;

    g["H"] = stn_hinf(v);
    g["R"] = stn_rinf(v);
    g["N"] = stn_ninf(v);
    g["C"] = stn_cinf(v);
    g["CA"] = 0.1;
    // Write in other currents
}
