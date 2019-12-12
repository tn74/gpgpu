//
// Created by Jasmine Lu on 2019-04-27.
//

#ifndef DBS_ON_GPU_STNNEURON_H
#define DBS_ON_GPU_STNNEURON_H


typedef struct stn_param {
    double C_m;
    double g_L;
    double E_L;
    double g_Na;
    double E_Na;
    double g_K;
    double E_K;
    double g_T;
    double E_T;
    double g_Ca;
    double E_Ca;
    double g_ahp;
    double E_ahp;
} stn_param_t;


typedef struct stn_state {
    double voltage;
    double I_Na;
    double I_L;
    double I_K;
    double I_T;
    double I_Ca;
    double I_ahp;
    double H;
    double R;
    double N;
    double C;
    double CA;
} stn_state_t;
 
__device__ void compute_next_state(stn_state_t *in, stn_state_t *out, stn_param_t *params, double dt);
__device__ void compute_currents(stn_state_t *in, stn_state_t *out, stn_param_t *params);
__device__ void compute_gating(stn_state_t *in, stn_state_t *out, stn_param_t *params, double dt);
void init_state(stn_state_t *in);

#endif //DBS_ON_GPU_STNNEURON_H
