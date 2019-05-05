//
// Created by Trishul Nagenalli on 2019-03-23.
//

#ifndef GPUIMPLEMENTATION_NEURON_H
#define GPUIMPLEMENTATION_NEURON_H

#include <map>
#include <vector>
#include "parameter_structs.h"


class Neuron {

protected:
    double duration;
    int dt_index;
    double dt;

    // For output purposes only
    std::string* cell_identifier;
    FILE* output_file;
    std::map<std::string, double>* map_currents;
    std::map<std::string, double>* map_gates;

    virtual void initialize_gating_variables() = 0;

public:
    std::vector<double>* voltage;                       // Track cell's voltage
    Neuron(double dt, double duration, double start_voltage);
    virtual int debug() = 0;
    int debug_write();
};


#endif //GPUIMPLEMENTATION_NEURON_H
