//
// Created by Trishul Nagenalli on 2019-03-23.
//

#include "Neuron.h"
#include <map>
#include <string>

Neuron::Neuron(double delta, double simulation_duration, double start_voltage, std::map<std::string, double> &neuron_parameters) {
    voltage.reserve((unsigned long) (duration/dt));
    voltage[0] = start_voltage;
    dt = delta;
    duration = simulation_duration;
    dt_index = 1;
    parameters = neuron_parameters;
}

std::vector<double> Neuron::get_voltages() {
    return voltage;
}

void Neuron::advance_time_step() {
    compute_currents();
    compute_gating_variables();
    double current_sum = 0.0;
    for(auto iter = currents.begin(); iter != currents.end(); ++iter)
    {
        current_sum += iter->second;
    }
    voltage[dt_index] = voltage[dt_index-1] + current_sum / parameters["C"];
}
