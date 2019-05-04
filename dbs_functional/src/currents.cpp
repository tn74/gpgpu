//
// Created by Trishul Nagenalli on 2019-05-04.
//

#include "currents.h"

//__device__ th_compute_currents(double* v_in, ) {
//    std::map<std::string, double> &c = *currents;
//    std::map<std::string, double> &p = *parameters;
//    std::map<std::string, double> &g = *gating_variables;
//    double v = (*voltage)[dt_index];
//
//    c["I_L"] = -(p["g_L"] * (v - p["E_L"]));
//    c["I_Na"] = -(p["g_Na"] * (pow(th_minf(v), 3)) * g["H"] * (v - p["E_Na"]));
//    c["I_K"] = -(p["g_K"] * pow(0.75 *(1 - g["H"]), 4) * (v - p["E_K"])); // SAME AS MATLAB BUT DIFFERENT FROM PAPER
//    c["I_T"] = -(p["g_T"] * pow(th_pinf(v), 2) * g["R"] * (v - p["E_T"]));
//}
//
//void THNeuron::compute_gating_variables() {
//    std::map<std::string, double> &g = *gating_variables;
//    double v = (*voltage)[dt_index];
//    g["H"] = g["H"] + dt * (th_hinf(v) - g["H"])/th_tauh(v);
//    g["R"] = g["R"] + dt * (th_rinf(v) - g["R"])/th_taur(v);
//}