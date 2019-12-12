//
// Created by Jasmine Lu on 2019-04-27.
//

#include "STNNeuron.h"
#include "gating.h"


__device__ void compute_next_state(stn_state_t *in, stn_state_t *out, stn_param_t *params, double dt){
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

__device__ void compute_currents(stn_state_t *in, stn_state_t *out, stn_param_t *params){
    out->I_L = -(params->g_L * (in->voltage - params->E_L));
    out->I_Na = -(params->g_Na * (pow(stn_minf(in->voltage), 3)) * in->H * (in->voltage- params->E_Na));
    out->I_K = -(params->g_K * pow(in->N, 4) * (in->voltage- params->E_K));
    out->I_T = -(params->g_T * pow(stn_ainf(in->voltage), 3) * pow(stn_binf(in->R), 2) * in->R * (in->voltage- params->E_Ca));
    out->I_Ca = -(params->g_Ca * pow(in->C, 2) * (in->voltage- params->E_Ca));
    out->I_ahp = -(params->g_ahp * (in->voltage- params->E_ahp) * (in->CA/(in->CA + 15)));
}
__device__ void compute_gating(stn_state_t *in, stn_state_t *out, stn_param_t *params, double dt){
    out->H = in->H + dt * 0.75 * ((stn_hinf(in->voltage) - in->H)/stn_tauh(in->voltage));
    out->R = in->R + dt * 0.2 * (stn_rinf(in->voltage) - in->R)/stn_taur(in->voltage);
    out->N = in->N + dt * 0.75 * (stn_ninf(in->voltage) - in->N)/stn_taun(in->voltage);
    out->C = in->C + dt * 0.08 * (stn_cinf(in->voltage) - in->C)/stn_tauc(in->voltage);
    out->CA = in->CA + dt * 3.75 * pow(10, -5) * (-(in->I_Ca) - in->I_T - (22.5 * in->CA));
}
void init_state(stn_state_t *in){
    in->voltage = -57.0;
    in->H = stn_hinf(in->voltage);
    in->R = stn_rinf(in->voltage);
    in->N = stn_ninf(in->voltage);
    in->C = stn_cinf(in->voltage);
    in->CA = 0.1;
}

void init_stn_param(stn_param_t* param) {
    param->C_m = 1.0;
    param->g_L = 2.25;
    param->E_L = -60.0;
    param->g_Na = 37.0;
    param->E_Na = 55.0;
    param->g_K = 45.0;
    param->E_K = -80.0;
    param->g_T = 0.5;
    param->E_T = 0.0;
    param->g_Ca = 2.0;
    param->E_Ca = 140.0;
    param->g_ahp = 20.0;
    param->E_ahp = -80.0;
}
