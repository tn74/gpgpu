//
// Created by Trishul Nagenalli on 2019-03-23.
//

#ifndef GPUIMPLEMENTATION_NEURON_H
#define GPUIMPLEMENTATION_NEURON_H

#include <vector>

class Neuron {

private:
    double voltage;
    std::vector<double> parameters;

public:
    Neuron(double dt, double duration, double start_voltage);
};


#endif //GPUIMPLEMENTATION_NEURON_H
