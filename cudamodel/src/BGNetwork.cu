//
// Created by Trishul Nagenalli on 2019-04-04.
//

#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include "BGNetwork.h"
#include "THNeuron.h"
#include "STNNeuron.h"

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
    if (cell_type == 1) {
        stn_state_t* state_series = ((stn_state_t***)states)[cell_type][cell_ind];
        stn_param_t* param = (stn_param_t*) params[0];
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
        this->states[i][STN] = (void**) malloc(cell_counts * sizeof(void**));
        cudaMallocManaged(&(this->states[i]), CELL_TYPE_COUNT * sizeof(void**));
        cudaMallocManaged(&(this->states[i][TH]), cell_counts * sizeof(void*));
        cudaMallocManaged(&(this->states[i][STN]), cell_counts * sizeof(void*));
        std::cout << "Assigned and Cuda Malloc Managed STATE " << i << " TH \n";
        for (int cell_ind = 0; cell_ind < cell_counts; ++cell_ind) {
            this->states[i][TH][cell_ind] = (th_state_t*) malloc(STEPS_PER_THREAD * sizeof(th_state));
            cudaMallocManaged(&(this->states[i][TH][cell_ind]), STEPS_PER_THREAD * sizeof(th_state));
            this->states[i][STN][cell_ind] = (stn_state_t*) malloc(STEPS_PER_THREAD * sizeof(stn_state));
            cudaMallocManaged(&(this->states[i][STN][cell_ind]), STEPS_PER_THREAD * sizeof(stn_state));
        }
    }
}

void BGNetwork::init_parameters() {
    this->params = (void**) malloc(CELL_TYPE_COUNT * sizeof(void*)); 
    cudaMallocManaged(&(this->params), CELL_TYPE_COUNT * sizeof(void*)); 
    this -> init_th_param();
    this -> init_stn_param();
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
            if (k == STN){(this->debug_states)[k][cell_ind] = (stn_state_t*) malloc(total_dt * sizeof(stn_state_t));}
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


void BGNetwork::init_stn_param() {
    this->params[STN] = malloc(sizeof(stn_param_t));
    cudaMallocManaged(&params[STN], sizeof(stn_param_t));
    auto stn_param = (stn_param_t *) params[STN];
    stn_param->C_m = 1.0;
    stn_param->g_L = 2.25;
    stn_param->E_L = -60.0;
    stn_param->g_Na = 37.0;
    stn_param->E_Na = 55.0;
    stn_param->g_K = 45.0;
    stn_param->E_K = -80.0;
    stn_param->g_T = 0.5;
    stn_param->E_T = 0.0;
    stn_param->g_Ca = 2.0;
    stn_param->E_Ca = 140.0;
    stn_param->g_ahp = 20.0;
    stn_param->E_ahp = -80.0;
    std::cout << "Built Parameter Map" << std::endl;
}

void BGNetwork::initialize_cells() {
    auto th_start = (th_state_t**) this->states[0][TH];
    auto stn_start = (stn_state_t**) this->states[0][STN];
    for (int i = 0; i < sim_params-> cells_per_type; ++i) {
        init_state(&th_start[i][0]); //0'th time index of each cell
        init_state(&stn_start[i][0]);
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
            ((stn_state_t***) to_states)[STN][cell_ind][t].voltage = ((stn_state_t***) from_states) [STN][cell_ind][t].voltage;
            //((th_state_t***) to_states)[GPE][cell_ind][t].voltage = ((th_state_t***) from_states) [GPE][cell_ind][t].voltage;
            //((th_state_t***) to_states)[GPI][cell_ind][t].voltage = ((th_state_t***) from_states) [GPI][cell_ind][t].voltage;
        }
    }
}


void BGNetwork::transfer_states(void*** from_states, void*** to_states, int from_t, int to_t, int number_of_states) {
    for (int t = 0; t < number_of_states; ++t) {
        for (int cell_ind = 0; cell_ind < this->sim_params->cells_per_type;++cell_ind) {
            ((th_state_t***) to_states)[TH][cell_ind][to_t + t] = ((th_state_t***) from_states) [TH][cell_ind][from_t + t];
            ((stn_state_t***) to_states)[STN][cell_ind][t].voltage = ((stn_state_t***) from_states) [STN][cell_ind][t].voltage;
            //((th_state_t***) to_states)[GPE][cell_ind][t].voltage = ((th_state_t***) from_states) [GPE][cell_ind][t].voltage;
            //((th_state_t***) to_states)[GPI][cell_ind][t].voltage = ((th_state_t***) from_states) [GPI][cell_ind][t].voltage;
        }
    }
}


void BGNetwork::advance_simulation() {
    /*
    int executions = 0;
    void*** sim_state = this->states[executions  % STATE_COUNT];
    void*** rest_state = this->states[(executions + 1) % STATE_COUNT];
    int block_count = (sim_params->cells_per_type * CELL_TYPE_COUNT) / THREADS_PER_BLOCK;
    if ((sim_params->cells_per_type * CELL_TYPE_COUNT) % THREADS_PER_BLOCK > 0){block_count ++;}
    
    //std::cout << "Cuda Error: " << cudaGetErrorString(cudaGetLastError()) << std::endl;
    advance_step<<<block_count, THREADS_PER_BLOCK>>>(sim_state, params, sim_params->cells_per_type, sim_params->dt, THREADS_PER_BLOCK, STEPS_PER_THREAD - 1);
    cudaDeviceSynchronize();
    //std::cout << "Cuda Error: " << cudaGetErrorString(cudaGetLastError()) << std::endl;
   

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
    std::cout << "\r"  << "Iteration: " << dt_index << std::endl;
*/
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
        void*** rest_state = this->states[(cycles - 1) % STATE_COUNT];
        int block_count = (sim_params->cells_per_type * CELL_TYPE_COUNT) / THREADS_PER_BLOCK;
        if ((sim_params->cells_per_type * CELL_TYPE_COUNT) % THREADS_PER_BLOCK > 0){block_count ++;}
        
        std::cout << "Cuda Error: " << cudaGetErrorString(cudaGetLastError()) << std::endl;
        advance_step<<<block_count, THREADS_PER_BLOCK>>>(sim_state, params, sim_params->cells_per_type, sim_params->dt, THREADS_PER_BLOCK, cycle_steps);
        if (cycles > 0) {this -> transfer_states(this->debug_states, this->debug_states, step, step, cycle_steps);}        
        cudaDeviceSynchronize();
        std::cout << "Cuda Error: " << cudaGetErrorString(cudaGetLastError()) << std::endl;
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
