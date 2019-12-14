from matplotlib import pyplot as plt
import json
import comparison

class StateViewer:
    def __init__(self, debug_dict):
        self.debug_dict = debug_dict
        for cell_type, info in self.debug_dict.items():
            for nm, val in list(info.items()):
                info.pop(nm)
                info[nm.replace("_", "")] = val

    def print_index(self, cell_type, index):
        for k, v in self.debug_dict[cell_type].items():
            print(f"{k}: {v[0][index]}")


    def compare_states(self, other, cell_type, index):
        for k, v in self.debug_dict[cell_type].items():
            oth_info = other.debug_dict[cell_type].get(k, None)
            if oth_info:
                oth_val = oth_info[0][index]
            else:
                oth_val = "missing"
            print(f"{k}: {v[0][index]}  {oth_val}")



LOADER = comparison.Loader()
COMPARATOR = comparison.Comparator()


matlab = LOADER.load_matlab("healthy_isolated_cells")
cuda = LOADER.load_cpp("cudamodel/saved_tests/basic2")
thresh = 1e-5
for i in range(1, len(cuda["TH"]["VOLTAGE"])):
    assert abs(cuda["TH"]["VOLTAGE"][0][i] - matlab["TH"]["VOLTAGE"][0][i]) < thresh

COMPARATOR.plot_voltage_differential(matlab, cuda)
