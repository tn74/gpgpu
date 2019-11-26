//
// Created by Trishul Nagenalli on 2019-03-28.
//


#include <string>
#include <iostream>
#include <string>
#include <sstream>
#include <iomanip>
#include <math.h>
#include "THNeuron.cuh"
#include "gating.cuh"

__global__ void trap() {
    int x = 1;
}
 
void compute_next_state(th_state_t *in, th_state_t *out, th_param_t *params, double dt) {
    trap<<<1, 1>>>();
    compute_currents(in, out, params);
    compute_gating(in, out, params, dt);
    double current_sum =
            out -> I_L +
            out -> I_Na +
            out -> I_K +
            out -> I_T;
    out -> voltage = in -> voltage + dt * current_sum / params->C_m;

}
void compute_currents(th_state_t *in, th_state_t *out, th_param_t *p){
    double v = in->voltage;
    out->I_K = -(p->g_K * pow(0.75 *(1 - in->H), 4) * (v - p->E_K));
    out->I_L = -1 * p->g_L * (v - p->E_L);
    out->I_Na = -1 * p->g_Na * pow(th_minf(v), 3) * in->H * (v - p->E_Na);
    out->I_T = -p->g_T * pow(th_pinf(v), 2) * in->R * (v - p->E_T);

}

void compute_gating(th_state_t *in, th_state_t *out, th_param_t *params, double dt){
    double v = in->voltage;
    out->H = in->H + dt * (th_hinf(v) - in->H)/th_tauh(v);
    out->R = in->R + dt * (th_rinf(v) - in->R)/th_taur(v);
}

void init_state(th_state_t *in){
    in->voltage = -57.0;
    in->H = th_hinf(in->voltage);
    in->R = th_rinf(in->voltage);
    in -> I_K = 0;
    in -> I_L = 0;
    in -> I_Na = 0;
    in -> I_T = 0;
}

std::string get_debug_string(th_state_t* state) {
    std::ostringstream debug_str;
    debug_str.setf(std::ios::fixed, std::ios::floatfield);
    debug_str << std::setprecision(15);
    debug_str
    << "VOLTAGE=" << state->voltage
    << ", I_K=" << state -> I_K
    << ", I_L=" << state -> I_L
    << ", I_Na=" << state -> I_Na
    << ", I_T=" << state -> I_T
    << ", H=" << state -> H
    << ", R=" << state -> R;
    return debug_str.str();
}
