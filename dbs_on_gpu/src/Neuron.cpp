//
// Created by Trishul Nagenalli on 2019-03-23.
//

#include "Neuron.h"
#include <map>
#include <string>
#include <iostream>

Neuron::Neuron(double delta, double simulation_duration, double start_voltage, std::map<std::string, double>* neuron_parameters) {
    std::cout << "Began Neuron Constructor" << std::endl;
    dt = delta;
    duration = simulation_duration;
    dt_index = 1;
    parameters = neuron_parameters;
    voltage = new std::vector<double>();
    currents = new std::map<std::string, double>();

    voltage->reserve((unsigned long) (duration/dt));
    voltage->push_back(start_voltage);
}

std::vector<double>* Neuron::get_voltages() {
    return voltage;
}

void Neuron::advance_time_step() {
    compute_currents();
    compute_gating_variables();
    double current_sum = 0.0;
    for(auto iter = currents->begin(); iter != currents->end(); ++iter) {
        current_sum += iter->second;
//        std::cout << "Iter Second: " << iter->second << std::endl;
    }
    (*voltage)[dt_index] =  (*voltage)[dt_index-1] + dt * current_sum / (*parameters)["C_m"];

    std::cout << "Time: " << dt * dt_index << ", DT INDEX: " << dt_index << ", DT = " << dt << std::endl;
    dt_index = dt_index + 1;

}
