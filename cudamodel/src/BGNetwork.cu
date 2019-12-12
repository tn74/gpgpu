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
    // Execute based on cell type
    if (cell_ind >= number_of_cells){return;}
    if (cell_type == 0) {
        th_state_t* state_series = ((th_state_t***)states)[cell_type][cell_ind];
        th_param_t* param = (th_param_t*) params[0];
        for (int timestep = 0; timestep < timesteps_to_run; ++timestep) {
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


BGNetwork::BGNetwork(simulation_parameters_t* sp){
    std::cout << "BGNetwork Constructor" << std::endl;
    this -> sim_params = sp;
    this -> init_states();
    std::cout << "Finished Init States" << std::endl;
    this -> init_parameters();     
    std::cout << "Initialized Parameters" << std::endl;
    this -> initialize_cells();
    std::cout << "Initialized Cells" << std::endl;
    this -> init_result_structures();
    std::cout << "Initialized Result Structures" << std::endl;
}


void BGNetwork::transfer_voltage(void*** from_states, void*** to_states, int from_t, int to_t, int number_of_states) {
    for (int t = 0; t < number_of_states; ++t) {
        for (int cell_ind = 0; cell_ind < this->sim_params->cells_per_type;++cell_ind) {
            ((th_state_t***) to_states)[TH][cell_ind][to_t + t].voltage = ((th_state_t***) from_states) [TH][cell_ind][from_t + t].voltage;
            //((th_state_t***) to_states)[STN][cell_ind][t].voltage = ((th_state_t***) from_states) [STN][cell_ind][t].voltage;
            //((th_state_t***) to_states)[GPE][cell_ind][t].voltage = ((th_state_t***) from_states) [GPE][cell_ind][t].voltage;
            //((th_state_t***) to_states)[GPI][cell_ind][t].voltage = ((th_state_t***) from_states) [GPI][cell_ind][t].voltage;
        }
    }
}


void BGNetwork::transfer_states(void*** from_states, void*** to_states, int from_t, int to_t, int number_of_states) {
    for (int t = 0; t < number_of_states; ++t) {
        for (int cell_ind = 0; cell_ind < this->sim_params->cells_per_type;++cell_ind) {
            ((th_state_t***) to_states)[TH][cell_ind][to_t + t] = ((th_state_t***) from_states) [TH][cell_ind][from_t + t];
            //((th_state_t***) to_states)[STN][cell_ind][t].voltage = ((th_state_t***) from_states) [STN][cell_ind][t].voltage;
            //((th_state_t***) to_states)[GPE][cell_ind][t].voltage = ((th_state_t***) from_states) [GPE][cell_ind][t].voltage;
            //((th_state_t***) to_states)[GPI][cell_ind][t].voltage = ((th_state_t***) from_states) [GPI][cell_ind][t].voltage;
        }
    }
}

int BGNetwork::simulate() {
    return 0;
}

int BGNetwork::simulate_debug() {
    int total_steps = this->sim_params->duration / this->sim_params->dt;
    int step = 0;
    int cycles= 0;
    std::cout << "Total Steps: " << total_steps << std::endl;
    while(step < total_steps) {
        int cycle_steps = total_steps - step;
        if (cycle_steps >= STEPS_PER_THREAD-1) {cycle_steps = STEPS_PER_THREAD-1;}
     
        void*** sim_state = this->states[cycles  % STATE_COUNT];
        void*** rest_state = this->states[(cycles + 1) % STATE_COUNT];
        int block_count = (sim_params->cells_per_type * CELL_TYPE_COUNT) / THREADS_PER_BLOCK;
        if ((sim_params->cells_per_type * CELL_TYPE_COUNT) % THREADS_PER_BLOCK > 0){block_count ++;}
        
        std::cout << "Cuda Error: " << cudaGetErrorString(cudaGetLastError()) << std::endl;
        advance_step<<<block_count, THREADS_PER_BLOCK>>>(sim_state, params, sim_params->cells_per_type, sim_params->dt, THREADS_PER_BLOCK, cycle_steps);
        cudaDeviceSynchronize();
        this -> transfer_states(sim_state, this->debug_states, 0, step, cycle_steps);        
        std::cout << "Cuda Error: " << cudaGetErrorString(cudaGetLastError()) << std::endl;
        this -> transfer_states(sim_state, rest_state, cycle_steps, 0, 1);
        
        cycles++;
        step += cycle_steps;
        if (step == total_steps) {this -> transfer_states(sim_state, this->debug_states, 0, step, cycle_steps);}
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
