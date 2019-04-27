//
// Created by Jasmine Lu on 2019-04-27.
//

#ifndef DBS_ON_GPU_GPINEURON_H
#define DBS_ON_GPU_GPINEURON_H

#include "Neuron.h"

class GPiNeuron : public Neuron{
private:
    double h_gate;
    double r_gate;
    double n_gate;
    double CA;

protected:
    void compute_currents() override;
    void compute_gating_variables() override;
    void initialize_gating_variables() override;

public:
    GPiNeuron(double dt, double duration, double start_voltage, std::map<std::string, double>* parameters);
};


#endif //DBS_ON_GPU_GPINEURON_H
