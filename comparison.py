from scipy.io import loadmat
import os
from shutil import copytree


def get_cell_type(key_string):
    if key_string.startswith(("th_", "stn_", "gpe_", "gpi_")):
        return key_string.split("_")[0]
    return None


def parse_mat(matfile):
    parsed_data = {"th": {}, "stn": {}, "gpe": {}, "gpi": {}}
    for key, value in matfile.items():
        cell_type = get_cell_type(key)
        if cell_type is None:
            continue
        debug_val = key.split("_")[1]
        parsed_data[cell_type][debug_val] = value
    return parsed_data


def load_matlab(test_name):
    basepath = os.path.dirname(os.path.abspath(__file__))
    test_path = os.path.join(basepath, "Model", "BGNetwork", "saved_tests", "{}.mat".format(test_name))
    return parse_mat(loadmat(test_path))


if __name__ == "__main__":
    for k, v in load_matlab("healthy_isolated_cells").items():
        print(k)
        for k2 in v.keys():
            print(k2)
        print()