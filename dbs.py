from scipy.io import loadmat
import ctypes

CELL_TYPE_COUNT = 1
DBSC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbs.so")
TESTC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbstest.so")
DBSC.execute_simulation.restype = ctypes.POINTER(ctypes.POINTER(ctypes.POINTER(ctypes.c_double)))

class SimulationParameters(ctypes.Structure):
   _fields_ = [
        ("dt", ctypes.c_double),
        ("duration", ctypes.c_double),
        ("cells_per_type", ctypes.c_int)
    ]

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

def execute_simulation(sim_params):
    print("Starting Python Execute Sim")
    sp_ptr = get_pointer(SimulationParameters, sim_params)
    start_time = time.time()
    ptr = DBSC.execute_simulation(sp_ptr)
    print("--- %s seconds ---" % (time.time() - start_time))
    return sim_results_to_py(sim_params, ptr)


class DBS():
    def load_initial_conditions(self, path):
        loadmat(path)


