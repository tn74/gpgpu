//
// Created by Trishul Nagenalli on 2019-03-28.
//


#include <string>
#include <iostream>
#include <math.h>
#include "THNeuron.h"
#include "gating.h"


void th_compute_next_state(th_state_t* in, th_state_t* out, th_param_t* params, double dt) {
    th_compute_currents(in, out, params);
    th_compute_gating(in, out, params);
    double current_sum =
            out -> I_L +
            out -> I_Na +
            out -> I_K +
            out -> I_T;
    out -> voltage = in -> voltage + dt * current_sum / params->C_m;

}
void th_compute_currents(th_state_t* in, th_state_t* out, th_param_t* params){

}
void th_compute_gating(th_state_t* in, th_state_t* out, th_param_t* params){

}
void th_init_state(th_state_t* state){

}
