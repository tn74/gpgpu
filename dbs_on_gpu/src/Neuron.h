//
// Created by Trishul Nagenalli on 2019-03-23.
//

#ifndef GPUIMPLEMENTATION_NEURON_H
#define GPUIMPLEMENTATION_NEURON_H

#include <map>
#include <vector>


class Neuron {

protected:
    double duration;
    int dt_index;
    double dt;
    std::vector<double>* voltage;
    std::map<std::string, double>* parameters;
    std::map<std::string, double>* currents;

    virtual void compute_currents() = 0;
    virtual void compute_gating_variables() = 0;

public:
    Neuron(double dt, double duration, double start_voltage, std::map<std::string, double>* parameters);

    std::vector<double>* get_voltages();
    virtual void advance_time_step();
};


#endif //GPUIMPLEMENTATION_NEURON_H
