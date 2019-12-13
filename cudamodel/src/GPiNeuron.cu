//
// Created by Jasmine Lu on 2019-04-27.
//

#include <string>
#include <iostream>
#include <sstream>
#include <iomanip>
#include "GPiNeuron.h"
#include "gating.h"


__device__ 
void compute_next_state(gpi_state_t *in, gpi_state_t *out, gpi_param_t *params, double dt){
    compute_currents(in, out, params);
    compute_gating(in, out, params, dt);
    
    out -> voltage = params -> g_L;
    double current_sum =
            out -> I_L +
            out -> I_Na +
            out -> I_K +
            out -> I_T +
            out -> I_Ca +
            out -> I_ahp;
    out -> voltage = in -> voltage + dt * current_sum / params->C_m;
}
__device__ 
void compute_currents(gpi_state_t *in, gpi_state_t *out, gpi_param_t *params){
    double v = in -> voltage;
    out->I_L = -(params->g_L * (v - params->E_L));
    out->I_Na = -(params->g_Na * (pow(gpe_minf(v), 3)) * in->H * (v - params->E_Na));
    out->I_K = -(params->g_K * pow(in->N, 4) * (v - params->E_K));
    out->I_T = -(params->g_T * pow(gpe_ainf(v), 3) * in->R * (v - params->E_Ca));
    out->I_Ca = -(params->g_Ca * pow(gpe_sinf(v), 3) * (v - params->E_Ca));
    out->I_ahp = -(params->g_ahp * (v - params->E_ahp) * (in->CA/(in->CA + 10)));
}


__device__ 
void compute_gating(gpi_state_t *in, gpi_state_t *out, gpi_param_t *params, double dt){
    double v = in->voltage;
    out->H= in->H + dt * 0.05 * ((gpe_hinf(v) - in->H)/gpe_tauh(v));
    out->R= in->R + dt * 1.0 * (gpe_rinf(v) - in->R)/30;
    out->N= in->N+ dt * 0.1 * (gpe_ninf(v) - in->N)/gpe_taun(v);
    out->CA = in->CA + dt * pow(10, -4) * (-(in->I_Ca) - in->I_T - (15 * in->CA));
}


void init_state(gpi_state_t *in){
    in->voltage = -57.0;
    double v = in->voltage;
    in->H = gpe_hinf(v);
    in->R = gpe_rinf(v);
    in->N = gpe_ninf(v);
    in->CA = 0.1;
}


void init_gpi_param(gpi_param_t *param){
    param->C_m = 1.0;
    param->g_L = 0.1;
    param->E_L = -65.0;
    param->g_Na = 120.0;
    param->E_Na = 55.0;
    param->g_K = 30.0;
    param->E_K = -80.0;
    param->g_T = 0.5;
    param->E_T = 0.0;
    param->g_Ca = 0.15;
    param->E_Ca = 120.0;
    param->g_ahp = 10.0;
    param->E_ahp = -80.0;
}


std::string get_debug_string(gpi_state_t* state) {
    std::ostringstream debug_str;
    debug_str.setf(std::ios::fixed, std::ios::floatfield);
    debug_str << std::setprecision(15);
    debug_str
        << "VOLTAGE=" << state->voltage
        << ", I_L=" << state->I_Na
        << ", I_Na= " << state->I_L
        << ", I_K=" << state->I_K
        << ", I_T=" << state->I_T
        << ", I_Ca=" << state->I_Ca
        << ", I_ahp=" << state->I_ahp
        << ", H=" << state->H
        << ", R=" << state->R
        << ", N=" << state->N
        << ", CA=" << state->CA;
    return debug_str.str();
}
