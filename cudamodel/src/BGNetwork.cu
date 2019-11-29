//
// Created by Trishul Nagenalli on 2019-04-04.
//

#include <iostream>
#include <string>
#include <sstream>
#include <fstream>

#include "BGNetwork.h"
#include "THNeuron.h"

__global__ 
 void advance_step(void** start_state, void** end_state, void** params, int* cell_counts, double dt, int tbp) {   
    // Determine what start to end this is supposed to compute
    int cell_ind = blockIdx.y * tbp + threadIdx.x;
    int cell_type = blockIdx.x;
    if (cell_ind >= cell_counts[cell_type]) {return;}

    // Execute based on cell type
//    if (cell_type == TH) {
        auto start = ((th_state_t**)start_state)[TH][cell_ind];
        auto end = ((th_state_t**) end_state)[TH][cell_ind];
        auto param = ((th_param_t**) params)[TH];
//    }

    compute_next_state(&start, &end, param, dt);
}


BGNetwork::BGNetwork(simulation_parameters_t* sp){
    std::cout << "BGNetwork Constructor" << std::endl;
    sim_params = sp;
    dt_index = 0;
    // params =        (void**) cudaMalloc(CELL_TYPE_COUNT * sizeof(void*));i
    size_t CTC_SIZE = CELL_TYPE_COUNT * sizeof(void*);
    params = (void**) malloc(CTC_SIZE); cudaMallocManaged(&params, CTC_SIZE);
    start_st = (void**) malloc(CTC_SIZE); cudaMallocManaged(&end_st, CTC_SIZE);
    end_st  = (void**) malloc(CTC_SIZE); cudaMallocManaged(&start_st, CTC_SIZE);
    std::cout << " OG " << cell_counts << std::endl;
    cell_counts  = (int*) malloc(CELL_TYPE_COUNT * sizeof(int*)); cudaMallocManaged(&cell_counts, CELL_TYPE_COUNT * sizeof(int*));
    std::cout << cell_counts << " " << cell_counts + 1 <<  std::endl;
    std::cout << *cell_counts << std::endl;
    for (int c = 0; c < CELL_TYPE_COUNT; ++c) {cell_counts[c] = sp->cells_per_type;}

    start_st[TH] = malloc(cell_counts[TH] * sizeof(th_state));
    end_st[TH] = malloc(cell_counts[TH]  * sizeof(th_state));
    
    build_parameter_map();
    initialize_cells();

}

void BGNetwork::build_parameter_map() {
    params[TH] = malloc(sizeof(th_param));
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
    dim3 grid(1, sim_params -> cells_per_type / 64 + 1);
    advance_step<<<grid, 64>>>(start_st, end_st, params, cell_counts, sim_params->dt, THREADS_PER_BLOCK);
    cudaDeviceSynchronize();
    dt_index ++;
    void** tmp = start_st;
    start_st = end_st;
    end_st = tmp;
    std::cout << "\r"  << "Iteration: " << dt_index << std::endl;
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
    system("exec rm -r output/*");
    //debug(state_start);
    for (int i = 0; i < sim_params->duration / sim_params->dt; ++i) {
        advance_time_step();
    //    debug(state_start);
    }
    return 0;
};
