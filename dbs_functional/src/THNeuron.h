//
// Created by Trishul Nagenalli on 2019-03-28.
//

#ifndef DBS_ON_GPU_THNEURON_H
#define DBS_ON_GPU_THNEURON_H

#include "Neuron.h"
#include "parameter_structs.h"

typedef struct th_current {
    double I_L;
    double I_Na;
    double I_K;
    double I_T;
} th_current_t;

typedef struct th_gate {
    double H;
    double R;
} th_gate_t;

void compute_currents(double v, th_current_t*, th_param_t* p);
void compute_gating(double v, th_gate_t*, th_param_t* p);

class THNeuron : public Neuron{
private:
    th_param_t* cell_params;
    th_current_t* currents;
    th_gate_t* gates;

protected:
    void initialize_gating_variables() override;

public:
    THNeuron(double dt, double duration, double start_voltage, param_t* network_params, int id);
    int debug_write();
};


#endif //DBS_ON_GPU_THNEURON_H
