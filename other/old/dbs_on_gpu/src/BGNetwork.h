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
#include "GPiNeuron.h"
#include "GPeNeuron.h"
#include "STNNeuron.h"




class BGNetwork {
private:
    std::map<std::string, std::vector<Neuron*>* >* all_cells;                               // cell-type -> index -> cell
    std::map<std::string, std::map<std::string, double>* >* network_parameters;             // cell-type -> parameter map
    double duration;
    double dt;
    int NUMBER_OF_CELLS;

    void build_parameter_map();
    void initialize_cells();
    void run_cell_thread(Neuron*);

public:
    BGNetwork(int n, double dur, double delta);
    int simulate();
};


#endif //DBS_ON_GPU_BGNETWORK_H