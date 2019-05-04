//
// Created by Trishul Nagenalli on 2019-05-04.
//

#include "parameter_structs.h"


void initialize_th_param(th_param_t* t) {
    t -> C_m = 1.0;
    t -> g_L = 0.05;
    t -> E_L = -70;
    t -> g_Na = 3.0;
    t -> E_Na = 50.0;
    t -> g_K = 5.0;
    t -> E_K = -75.0;
    t -> g_T = 5.0;
    t -> E_T = 0.0;
}

void initialize_parameter_map(param_t* p) {
    initialize_th_param( p->th );
}