//
// Created by Jasmine Lu on 2019-04-27.
//

#ifndef DBS_ON_GPU_STNNEURON_H
#define DBS_ON_GPU_STNNEURON_H

#include "Neuron.h"

class STNNeuron : public Neuron{

protected:
    void compute_currents() override;
    void compute_gating_variables() override;
    void initialize_gating_variables() override;

public:
    STNNeuron(double dt, double duration, double start_voltage, std::map<std::string, double>* parameters, int id);
};


#endif //DBS_ON_GPU_STNNEURON_H
