//
// Created by Jasmine Lu on 2019-04-27.
//

#ifndef DBS_ON_GPU_gpiNEURON_H
#define DBS_ON_GPU_gpiNEURON_H

#include <string>

typedef struct gpi_param {
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
} gpi_param_t;


typedef struct gpi_state {
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
} gpi_state_t;
 
__device__ void compute_next_state(gpi_state_t *in, gpi_state_t *out, gpi_param_t *params, double dt);
__device__ void compute_currents(gpi_state_t *in, gpi_state_t *out, gpi_param_t *params);
__device__ void compute_gating(gpi_state_t *in, gpi_state_t *out, gpi_param_t *params, double dt);
void init_state(gpi_state_t *in);
void init_gpi_param(gpi_param_t *param);
std::string get_debug_string(gpi_state_t* state);
#endif //DBS_ON_GPU_gpiNEURON_H
