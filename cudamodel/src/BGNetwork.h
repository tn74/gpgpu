//
// Created by Trishul Nagenalli on 2019-04-04.
//


#include <string>
#include <vector>
#include <map>
#include "THNeuron.h"

#pragma once

#define TH 0
#define STN 1
#define GPE 2
#define GPI 3
#define CELL_TYPE_COUNT 1
#define THREADS_PER_BLOCK 64

typedef struct simulation_parameters {
    double dt;
    double duration;
    int cells_per_type;

} simulation_parameters_t;



class BGNetwork {
private:
    int dt_index;
    simulation_parameters_t* sim_params;
    void** start_st;
    void** end_st;
    void** params;
    int* cell_counts;
    double*** VOLTAGE;

    void build_parameter_map();
    void initialize_cells();
    void advance_time_step();

public:
    BGNetwork(simulation_parameters_t* sp);
    void debug(th_state_t*);
    int simulate();
    double*** get_voltage();
};


