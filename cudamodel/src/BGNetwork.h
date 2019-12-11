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
#define THREADS_PER_BLOCK 256
#define STATE_COUNT 2
#define STEPS_PER_THREAD 10

typedef struct simulation_parameters {
    double dt;
    double duration;
    int cells_per_type;
} simulation_parameters_t;



class BGNetwork {
private:
    int dt;
    simulation_parameters_t* sim_params;
    void**** states; // States Number, Cell Type, Cell Index, DT
    void** params;
    void*** debug_states;
    double*** voltage;

    void init_states(); 
    void init_parameters();
    void init_th_param();
    void initialize_cells();
    void init_result_structures();

    void copy_voltage();
    void copy_states();
    void advance_time_step();
    

public:
    BGNetwork(simulation_parameters_t* sp);
    int simulate_debug();
    int simulate();
    double*** get_voltage();
    void*** get_debug_states();
};


