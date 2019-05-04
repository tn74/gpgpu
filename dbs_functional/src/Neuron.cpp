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
        double start_voltage
        ) {
    std::cout << "Began Neuron Constructor" << std::endl;
    dt = delta;
    duration = simulation_duration;
    dt_index = 0;
    std::cout << "Before maps" << std::endl;
    voltage = new std::vector<double>();
    std::cout << "After voltage map" << std::endl;

    map_currents = new std::map<std::string, double>();
    map_gates = new std::map<std::string, double>();

    voltage->reserve((unsigned long) (duration/dt) + 1);
    voltage->push_back(start_voltage);
    std::cout << "After Neuron Constructor" << std::endl;

}


int Neuron::debug_write() {
    if (output_file == nullptr) {
        std::string filename = std::string("output/") + *cell_identifier;
        filename.append(".txt");
        output_file = fopen(filename.c_str(), "w");
    };

    fprintf(output_file, "DT=%d, VOLTAGE=%.15f", dt_index, voltage->back());
    for (auto& [current_name, amps]: *map_currents) {
        fprintf(output_file, ", %s=%.15f", current_name.c_str(), amps);
    }
    for (auto& [gate, volts]: *map_gates) {
        fprintf(output_file, ", %s=%.15f", gate.c_str(), volts);
    }
    fprintf(output_file, ", \n");

    if (dt_index == voltage->capacity() - 1) {
        fclose(output_file);
        std::cout << "File Closed" << std::endl;
    }
}