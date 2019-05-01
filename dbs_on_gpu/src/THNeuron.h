//
// Created by Trishul Nagenalli on 2019-03-28.
//

#ifndef DBS_ON_GPU_THNEURON_H
#define DBS_ON_GPU_THNEURON_H

#include "Neuron.h"

class THNeuron : public Neuron{
private:
    double h_gate;
    double r_gate;

protected:
    void compute_currents() override;
    void compute_gating_variables() override;
    void initialize_gating_variables() override;

public:
    THNeuron(double dt, double duration, double start_voltage, std::map<std::string, double>* parameters);
};


#endif //DBS_ON_GPU_THNEURON_H
