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

typedef struct current_matrix {
    th_current_t** th;
} current_matrix_t;

typedef struct gates_matrix {
    th_current_t** th;
} gates_matrix_t;

typedef struct compute_memory {
    double** v1;
    double** v2;
    param_t* network_parameters;
    current_matrix_t* c_mat;
    gates_matrix_t* g_mat;
} compute_memory_t;

class BGNetwork {
private:
    int dt_index;
    int number_of_cells;
    double duration;
    double dt;
    compute_memory_t* compute_mem;
    std::map<int, std::vector<Neuron*>*>* all_cells;                          // cell-type -> index -> cell

    void build_parameter_map();
    void initialize_cells();
    void advance_time_step();

public:
    BGNetwork(int n, double dur, double delta);
    int simulate();
};


#endif //DBS_ON_GPU_BGNETWORK_H
