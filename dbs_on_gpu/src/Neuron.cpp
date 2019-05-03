//
// Created by Trishul Nagenalli on 2019-03-23.
//

#include "Neuron.h"
#include <map>
#include <string>
#include <iostream>

Neuron::Neuron(
        double delta,
        double simulation_duration,
        double start_voltage, std::map<std::string,
        double>* neuron_parameters
        ) {
    std::cout << "Began Neuron Constructor" << std::endl;
    dt = delta;
    duration = simulation_duration;
    dt_index = 0;
    parameters = neuron_parameters;
    voltage = new std::vector<double>();
    currents = new std::map<std::string, double>();
    gating_variables = new std::map<std::string, double>();

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
    }
    voltage->push_back((*voltage)[dt_index] + dt * current_sum / (*parameters)["C_m"]);
    dt_index = dt_index + 1;
}

int Neuron::debug() {
    if (output_file == nullptr) {
        std::string filename = std::string("output/") + *cell_identifier;
//        std::string filename =  *cell_identifier;
        filename.append(".txt");
        output_file = fopen(filename.c_str(), "w");
    };

    fprintf(output_file, "DT=%d, VOLTAGE=%.15f", dt_index, voltage->back());
    for (auto& [current_name, amps]: *currents) {
        fprintf(output_file, ", %s=%.15f", current_name.c_str(), amps);
    }
    for (auto& [gate, volts]: *gating_variables) {
        fprintf(output_file, ", %s=%.15f", gate.c_str(), volts);
    }
    fprintf(output_file, ", \n");

//    std::cout << "DT Index = " << dt_index << ", Voltage Size = " << voltage->capacity() << std::endl;
    if (dt_index == voltage->capacity() - 1) {
        fclose(output_file);
        std::cout << "File Closed" << std::endl;
    }
}