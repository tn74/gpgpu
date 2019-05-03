//
// Created by Jasmine Lu on 2019-04-27.
//

#include "GPiNeuron.h"
#include "Neuron.h"
#include "gating.h"
#include <string>
#include <iostream>
#include <math.h>

GPiNeuron::GPiNeuron(
        double dt,
        double duration,
        double start_voltage,
        std::map<std::string,
        double>* parameters,
        int id
        ):Neuron(dt, duration, start_voltage, parameters){
    cell_identifier = new std::string("GPI_NEURON_" + std::to_string(id));
    initialize_gating_variables();
};

void GPiNeuron::compute_currents() {
    std::map<std::string, double> &c = *currents;
    std::map<std::string, double> &p = *parameters;
    std::map<std::string, double> &g = *gating_variables;

    double v = (*voltage)[dt_index];

    c["I_L"] = -(p["g_L"] * (v - p["E_L"]));
    c["I_Na"] = -(p["g_Na"] * (pow(gpe_minf(v), 3)) * g["H"] * (v - p["E_Na"]));
    c["I_K"] = -(p["g_K"] * pow(g["N"], 4) * (v - p["E_K"]));
    c["I_T"] = -(p["g_T"] * pow(gpe_ainf(v), 3) * g["R"] * (v - p["E_Ca"]));
    c["I_Ca"] = -(p["g_Ca"] * pow(gpe_sinf(v), 3) * (v - p["E_Ca"]));
    c["I_ahp"] = -(p["g_ahp"] * (v - p["E_ahp"]) * (g["CA"]/(g["CA"] + 10)));
}

void GPiNeuron::compute_gating_variables() {
    std::map<std::string, double> &c = *currents;
    std::map<std::string, double> &g = *gating_variables;


    double v = (*voltage)[dt_index];
    g["H"]= g["H"] + dt * 0.05 * ((gpe_hinf(v) - g["H"])/gpe_tauh(v));
    g["R"]= g["R"] + dt * 1.0 * (gpe_rinf(v) - g["R"])/30;
    g["N"]= g["N"]+ dt * 0.1 * (gpe_ninf(v) - g["N"])/gpe_taun(v);
    g["CA"] = g["CA"] + dt * pow(10, -4) * (-(c["I_Ca"]) - c["I_T"] - (15 * g["CA"]));
}

void GPiNeuron::initialize_gating_variables() {
    double v = (*voltage)[dt_index];
    std::map<std::string, double> &g = *gating_variables;

    g["H"] = gpe_hinf(v);
    g["R"] = gpe_rinf(v);
    g["N"] = gpe_ninf(v);
    g["CA"] = 0.1;
    // Write in other currents
}
