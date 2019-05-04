//
// Created by Trishul Nagenalli on 2019-04-04.
//

#ifndef DBS_ON_GPU_BGNETWORK_H
#define DBS_ON_GPU_BGNETWORK_H

#include <string>
#include <vector>
#include <map>
#include "Neuron.h"
#include "THNeuron.h"
#include "parameter_structs.h"


class BGNetwork {
private:
    int number_of_cells;
    double duration;
    double dt;
    param_t* network_parameters;
    std::map<std::string, std::vector<Neuron*>* >* all_cells;                             // cell-type -> index -> cell

    void build_parameter_map();
    void initialize_cells();
    void run_cell_thread(Neuron*);

public:
    BGNetwork(int n, double dur, double delta);
    int simulate();
};


#endif //DBS_ON_GPU_BGNETWORK_H
