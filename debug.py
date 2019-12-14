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


matarr = comparison.Loader().load_matlab('healthy_isolated_cells')
matState = StateViewer(matarr)
cudaState = StateViewer(healthy_cells)
matState.print_index("STN", 1)
print('')
cudaState.print_index("STN", 1)
print("")
matState.compare_states(cudaState, "STN", 0)
print("")
matState.compare_states(cudaState, "STN", 1)
