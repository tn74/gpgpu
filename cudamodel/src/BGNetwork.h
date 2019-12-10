//
// Created by Trishul Nagenalli on 2019-04-04.
//


#include <string>
#include <vector>
#include <map>

#pragma once

#define TH 0
#define STN 1
#define GPE 2
#define GPI 3
#define CELL_TYPE_COUNT 1
#define THREADS_PER_BLOCK 256
#define STATE_COUNT 3

typedef struct simulation_parameters {
    double dt;
    double duration;
    int cells_per_type;
} simulation_parameters_t;



class BGNetwork {
private:
    int dt;
    simulation_parameters_t* sim_params;
    void*** states;
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
    void debug(th_state_t*);
    int simulate();
    double*** get_voltage();
};


