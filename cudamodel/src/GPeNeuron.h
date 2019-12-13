//
// Created by Jasmine Lu on 2019-04-27.
//

#ifndef DBS_ON_GPU_gpeNEURON_H
#define DBS_ON_GPU_gpeNEURON_H

#include <string>

typedef struct gpe_param {
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
} gpe_param_t;


typedef struct gpe_state {
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
    double CA;
} gpe_state_t;
 
__device__ void compute_next_state(gpe_state_t *in, gpe_state_t *out, gpe_param_t *params, double dt);
__device__ void compute_currents(gpe_state_t *in, gpe_state_t *out, gpe_param_t *params);
__device__ void compute_gating(gpe_state_t *in, gpe_state_t *out, gpe_param_t *params, double dt);
void init_state(gpe_state_t *in);
void init_gpe_param(gpe_param_t *param);
std::string get_debug_string(gpe_state_t* state);
#endif //DBS_ON_GPU_gpeNEURON_H
