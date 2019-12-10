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
 void advance_step(void** start_state, void** end_state, void** params, int* cell_counts, double dt, int tbp) {   
     // Determine what start to end this is supposed to compute
    int cell_ind = blockIdx.y * tbp + threadIdx.x;
    int cell_type = blockIdx.x;
    if (cell_ind >= cell_counts[cell_type]) {return;}
    
    // Execute based on cell type
//    if (cell_type == TH) {
        th_state_t* start = &((th_state_t**)start_state)[TH][cell_ind];
        th_state_t* end = &((th_state_t**) end_state)[TH][cell_ind];
        th_param_t* param = ((th_param_t**) params)[TH];
//    }
    compute_next_state(start, end, param, dt);
}


void BGNetwork::init_states() {
    int cell_counts = this -> sim_params -> cells_per_type;
    this -> states = (void***) malloc(STATE_COUNT * sizeof(void*));
    for (int i = 0; i < STATE_COUNT; ++i) {
        this->states[i] = (void**) malloc(CELL_TYPE_COUNT * sizeof(void*));
        this->states[i][TH] = (void*) malloc(cell_counts * sizeof(th_state_t*));
        cudaMallocManaged(&(this->states[i]), CELL_TYPE_COUNT * sizeof(void*));
        cudaMallocManaged(&(this->states[i][TH]), cell_counts * sizeof(th_state_t*));
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
    this -> init_parameters();     
    this -> initialize_cells();

}

void BGNetwork::init_th_param() {
    this->params[TH] = malloc(sizeof(th_param));
    cudaMallocManaged(&params[TH], sizeof(th_param));
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
    auto th_start = (th_state_t*) start_st[TH];
    for (int i = 0; i < sim_params-> cells_per_type; ++i) {
        init_state(&th_start[i]);
    }
}

void BGNetwork::advance_time_step() {
    dim3 grid(CELL_TYPE_COUNT, sim_params -> cells_per_type / THREADS_PER_BLOCK + 1);
    advance_step<<<grid, THREADS_PER_BLOCK>>>(start_st, end_st, params, cell_counts, sim_params->dt, THREADS_PER_BLOCK);
    cudaDeviceSynchronize();
    //std::cout << "Out of CUDA Call" << std::endl; 
    //std::cout << ((th_state_t**) start_st) << ", " << ((th_state_t**) start_st)[0][0].voltage << std::endl; 
    //std::cout << cudaGetErrorString(cudaGetLastError()) << std::endl;
    for (int cell_type = 0; cell_type < CELL_TYPE_COUNT; ++cell_type) {
        for (int cell_ind = 0; cell_ind < sim_params->cells_per_type; ++cell_ind) { // Strangely cell_counts[TH] does not work here?!?! 
            VOLTAGE[cell_type][cell_ind][dt_index] = ((th_state_t**)start_st)[cell_type][cell_ind].voltage;
        }
    }
    dt_index ++;
    void** tmp = start_st;
    start_st = end_st;
    end_st = tmp;
    //std::cout << "\r"  << "Iteration: " << dt_index << std::endl;
}

void BGNetwork::debug(th_state_t* state) {
    for (int i = 0; i < sim_params->cells_per_type; ++i) {
        std::ostringstream output_file_name;
        output_file_name << "output/TH_NEURON_" << i << ".txt";
        std::ofstream out(output_file_name.str(), std::ios::app);
        out << "DT=" << dt_index << ", " << get_debug_string(&state[i]) << std::endl;
        out.close();
    }
}

int BGNetwork::simulate() {
    for (int i = 0; i < sim_params->duration / sim_params->dt; ++i) {
        advance_time_step();
    }
    std::cout<< "End of Simulate" << std::endl;
    return 0;
};

double*** BGNetwork::get_voltage() {
    return VOLTAGE;
}
