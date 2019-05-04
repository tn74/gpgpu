//
// Created by Trishul Nagenalli on 2019-05-04.
//

#ifndef DBS_FUNCTIONAL_PARAMETER_STRUCTS_H
#define DBS_FUNCTIONAL_PARAMETER_STRUCTS_H

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

typedef struct param {
    th_param_t* th;
} param_t;

void initialize_th_param (th_param_t*);
void initialize_parameter_map (param_t*);

#endif //DBS_FUNCTIONAL_PARAMETER_STRUCTS_H
