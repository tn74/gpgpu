//
// Created by Trishul Nagenalli on 2019-03-28.
//

#ifndef DBS_ON_GPU_THNEURON_H
#define DBS_ON_GPU_THNEURON_H


typedef struct th_param {
    double C_m;
    double g_L;
    double E_L;
    double g_Na;
    double E_Na;
    double g_K;
    double E_K;
    double g_T;
    double E_T;
} th_param_t;

typedef struct th_state {
    double voltage;
    double I_L;
    double I_Na;
    double I_K;
    double I_T;
    double H;
    double R;
} th_state_t;


void compute_next_state(th_state_t *in, th_state_t *out, th_param_t *params, double dt);
void compute_currents(th_state_t *in, th_state_t *out, th_param_t *params);
void compute_gating(th_state_t *in, th_state_t *out, th_param_t *params, double dt);
void init_state(th_state_t *in);
std::string get_debug_string(th_state_t* state);

#endif //DBS_ON_GPU_THNEURON_H
