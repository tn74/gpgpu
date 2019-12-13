from scipy.io import loadmat
from dbsstructs import *
import ctypes
import time


CELL_TYPE_COUNT = 1
DBSC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbs.so")
TESTC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbstest.so")
DBSC.execute_simulation.restype = ctypes.POINTER(ctypes.POINTER(ctypes.POINTER(ctypes.c_double)))
DBSC.execute_simulation_debug.restype = ctypes.POINTER(ctypes.POINTER(ctypes.POINTER(ctypes.c_char)))


def get_pointer(cls, dictionary):
    field_vals = []
    for fname, ftype in cls._fields_:
        field_vals.append(dictionary[fname])
    inst = cls(*field_vals)
    return ctypes.pointer(inst)

def sim_results_to_py(sim_params, double_pointer_array):
    time_steps = (int)(sim_params["duration"]/sim_params["dt"])
    voltages = []
    for cell_type in range(CELL_TYPE_COUNT):
        voltages.append([])
        for cell_ind in range(sim_params["cells_per_type"]):
            voltages[cell_type].append([])
            voltages[cell_type][cell_ind] = []
            for dt in range(time_steps):
                """
                print(f"{cell_type}, {cell_ind}, {dt}: {double_pointer_array[cell_type]}")
                print(f"{cell_type}, {cell_ind}, {dt}: {double_pointer_array[cell_type][cell_ind]}")
                print(f"{cell_type}, {cell_ind}, {dt}: {double_pointer_array[cell_type][cell_ind][dt]}")
                """
                voltages[cell_type][cell_ind].append(double_pointer_array[cell_type][cell_ind][dt])
    return voltages

def debug_results_to_py(sim_params, states_pointer_array):
    time_steps = (int)(sim_params["duration"]/sim_params["dt"])
    ret = {}
    ret["TH"] = {k.upper(): [[] for ci in range(sim_params["cells_per_type"])] for k, typ in THState._fields_}
    ret["STN"] = {k.upper(): [[] for ci in range(sim_params["cells_per_type"])] for k, typ in STNState._fields_}
    print(states_pointer_array)
    print(states_pointer_array.contents)
    print(ctypes.addressof(states_pointer_array.contents))
    print("Before Cast")
    TH_PTR = ctypes.cast(states_pointer_array, ctypes.POINTER(ctypes.POINTER(ctypes.POINTER(THState))))
    print("Casted TH")
    STN_PTR = ctypes.cast(states_pointer_array, ctypes.POINTER(ctypes.POINTER(ctypes.POINTER(STNState))))
    print("After Cast")
    for cell_ind in range(sim_params["cells_per_type"]):
        for t in range(time_steps):
            for k, typ in THState._fields_:
                #if k == "VOLTAGE":
                #    print(f"TH {cell_ind} {t} {k} {getattr(TH_PTR[cell_ind][t], k)}")
                ret["TH"][k.upper()][cell_ind].append(getattr(TH_PTR[0][cell_ind][t], k))
            for k, typ in STNState._fields_:
                #if k == "VOLTAGE":
                #    print(f"STN {cell_ind} {t} {k} {getattr(STN_PTR[cell_ind][t], k)}")
                ret["STN"][k.upper()][cell_ind].append(getattr(STN_PTR[1][cell_ind][t], k))
    return ret


def execute_simulation(sim_params):
    print("Starting Python Execute Sim")
    sp_ptr = get_pointer(SimulationParameters, sim_params)
    start_time = time.time()
    ptr = DBSC.execute_simulation(sp_ptr)
    print("--- %s seconds ---" % (time.time() - start_time))
    return sim_results_to_py(sim_params, ptr)

def execute_simulation_debug(sim_params):
    print("Starting Python Execute Sim Debug")
    sp_ptr = get_pointer(SimulationParameters, sim_params)
    ptr = DBSC.execute_simulation_debug(sp_ptr)
    return debug_results_to_py(sim_params, ptr)



