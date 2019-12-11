//
// Created by Trishul Nagenalli on 2019-04-04.
//

#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include "BGNetwork.h"
#include "THNeuron.h"
#include <chrono>
#include <thread>
__global__ 
 void advance_step(void*** states, void** params, int number_of_cells,  double dt, int tbp, int timesteps_to_run) {   
    int ctc = 4;
    int cell_ind = (blockIdx.x * tbp + threadIdx.x) / ctc;
    int cell_type = (blockIdx.x * tbp + threadIdx.x) % ctc;
    //(((th_state_t***)states)[0][0] + 1) -> voltage = 1; 
    // Execute based on cell type
    if (cell_ind >= number_of_cells){return;}
    if (cell_type == 0) {
        th_state_t* state_series = ((th_state_t***)states)[cell_type][cell_ind];
        //(state_series + 1) -> voltage = 2;
        th_param_t* param = (th_param_t*) params[0];
        //(state_series + 1) -> voltage = 3;
        for (int timestep = 0; timestep < timesteps_to_run; ++timestep) {
            //(&state_series[0]) -> voltage = 100 + timesteps_to_run;
            compute_next_state(state_series + timestep, state_series + timestep + 1, param, dt);
        }
    }
 }


void BGNetwork::init_states() {
    int cell_counts = this -> sim_params -> cells_per_type;
    this -> states = (void****) malloc(STATE_COUNT * sizeof(void***));
    for (int i = 0; i < STATE_COUNT; ++i) {
        this->states[i] = (void***) malloc(CELL_TYPE_COUNT * sizeof(void***));
        this->states[i][TH] = (void**) malloc(cell_counts * sizeof(void**));
        cudaMallocManaged(&(this->states[i]), CELL_TYPE_COUNT * sizeof(void**));
        cudaMallocManaged(&(this->states[i][TH]), cell_counts * sizeof(void*));
        std::cout << "Assigned and Cuda Malloc Managed STATE " << i << " TH \n";
        for (int cell_ind = 0; cell_ind < cell_counts; ++cell_ind) {
            std::cout << "Size of th_state_t " << sizeof(th_state_t) << " bytes" << "Size of th_state " << sizeof(th_state) << " bytes\n";    
            this->states[i][TH][cell_ind] = (th_state_t*) malloc(STEPS_PER_THREAD * sizeof(th_state));
            cudaMallocManaged(&(this->states[i][TH][cell_ind]), STEPS_PER_THREAD * sizeof(th_state));
        }
    }
}

void BGNetwork::init_parameters() {
    this->params = (void**) malloc(CELL_TYPE_COUNT * sizeof(void*)); 
    cudaMallocManaged(&(this->params), CELL_TYPE_COUNT * sizeof(void*)); 
    this -> init_th_param();
}

void BGNetwork::init_result_structures() {
    int cell_counts = this->sim_params->cells_per_type;
    double total_dt = this->sim_params->duration / this->sim_params->dt; 
    
    this -> voltage = (double***) malloc(sizeof(double**));
    this -> debug_states = (void***) malloc(sizeof(double**));
    for (int k = 0; k < CELL_TYPE_COUNT; ++k) { 
        (this->voltage)[k]       = (double**) malloc(cell_counts * sizeof(double*));
        (this->debug_states)[k]  = (void**) malloc(cell_counts * sizeof(void*));
        for (int cell_ind = 0; cell_ind < cell_counts; ++cell_ind) {
            (this->voltage)[k][cell_ind] = (double*) malloc(total_dt * sizeof(double));
            if (k == TH){(this->debug_states)[k][cell_ind] = (th_state_t*) malloc(total_dt * sizeof(th_state_t));}
        }
    }
}

BGNetwork::BGNetwork(simulation_parameters_t* sp){
    std::cout << "BGNetwork Constructor" << std::endl;
    this -> sim_params = sp;
    this -> dt = 0;
    this -> init_states();
    std::cout << "Finished Init States" << std::endl;
    this -> init_parameters();     
    std::cout << "Initialized Parameters" << std::endl;
    this -> initialize_cells();
    std::cout << "Initialized Cells" << std::endl;
    this -> init_result_structures();
    std::cout << "Initialized Result Structures" << std::endl;
}

void BGNetwork::init_th_param() {
    this->params[TH] = malloc(sizeof(th_param_t));
    cudaMallocManaged(&params[TH], sizeof(th_param_t));
    auto th_params = (th_param_t *) params[TH];
    th_params -> C_m = 1.0;
    th_params -> g_L = 0.05;
    th_params -> E_L = -70;
    th_params -> g_Na = 3.0;
    th_params -> E_Na = 50.0;
    th_params -> g_K = 5.0;
    th_params -> E_K = -75.0;
    th_params -> g_T = 5.0;
    th_params -> E_T = 0.0;
    std::cout << "Built Parameter Map" << std::endl;
}

void BGNetwork::initialize_cells() {
    auto th_start = (th_state_t**) this->states[0][TH];
    for (int i = 0; i < sim_params-> cells_per_type; ++i) {
        init_state(&th_start[i][0]); //0'th time index of each cell
    }
}

void BGNetwork::advance_time_step() {
    int executions = this->dt / STEPS_PER_THREAD;
    void*** sim_state = this->states[executions  % STATE_COUNT];
    void*** rest_state = this->states[(executions + 1) % STATE_COUNT];
    int block_count = (sim_params->cells_per_type * CELL_TYPE_COUNT) / THREADS_PER_BLOCK;
    if ((sim_params->cells_per_type * CELL_TYPE_COUNT) % THREADS_PER_BLOCK > 0){block_count ++;}
    
    std::cout << "Cuda Error: " << cudaGetErrorString(cudaGetLastError()) << std::endl;
    advance_step<<<block_count, THREADS_PER_BLOCK>>>(sim_state, params, sim_params->cells_per_type, sim_params->dt, THREADS_PER_BLOCK, STEPS_PER_THREAD - 1);
    cudaDeviceSynchronize();
    std::cout << "Cuda Error: " << cudaGetErrorString(cudaGetLastError()) << std::endl;
    /*
    for (int type = 0; type < CELL_TYPE_COUNT; ++type){
        for (int cell_ind = 0; this->sim_params->cells_per_type; ++cell_ind){ 
            rest_state[type][cell_ind][0] = ((th_state_t*) sim_state)[type][cell_ind][STEPS_PER_THREAD - 1];
        }
    }
    */
    dt += STEPS_PER_THREAD;
    //std::cout << "Out of CUDA Call" << std::endl; 
    //std::cout << ((th_state_t**) start_st) << ", " << ((th_state_t**) start_st)[0][0].voltage << std::endl; 
    //std::cout << cudaGetErrorString(cudaGetLastError()) << std::endl;
    /*
    for (int cell_type = 0; cell_type < CELL_TYPE_COUNT; ++cell_type) {
        for (int cell_ind = 0; cell_ind < sim_params->cells_per_type; ++cell_ind) { // Strangely cell_counts[TH] does not work here?!?! 
            VOLTAGE[cell_type][cell_ind][dt_index] = ((th_state_t**)start_st)[cell_type][cell_ind].voltage;
        }
    }
    dt_index ++;
    void** tmp = start_st;
    start_st = end_st;
    end_st = tmp;*/
    //std::cout << "\r"  << "Iteration: " << dt_index << std::endl;
}
/*
int BGNetwork::debug(th_state_t* state) {
    for (int i = 0; i < sim_params->cells_per_type; ++i) {
        std::ostringstream output_file_name;
        output_file_name << "output/TH_NEURON_" << i << ".txt";
        std::ofstream out(output_file_name.str(), std::ios::app);
        out << "DT=" << dt << ", " << get_debug_string(&state[i]) << std::endl;
        out.close();
    }
    return 0;
}
*/
int BGNetwork::simulate() {
    for (int i = 0; i < sim_params->duration / sim_params->dt; ++i) {
        advance_time_step();
    }
    std::cout<< "End of Simulate" << std::endl;
    return 0;
}


int BGNetwork::simulate_debug() {
    for (int i = 0; i < sim_params->duration / sim_params->dt; ++i) {
        advance_time_step();
    }
    std::cout<< "End of Simulate Debug" << std::endl;
    return 0;
}


double*** BGNetwork::get_voltage() {
    return this->voltage;
}


void*** BGNetwork::get_debug_states() {
    return this -> debug_states;
}
