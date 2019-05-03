from scipy.io import loadmat
import os
from shutil import copytree


def format_dict(d):
    current_keys = list(d.keys())
    for k in current_keys:
        if type(d[k]) == dict:
            format_dict(d[k])
        d[k.upper().replace("_", "")] = d.pop(k)
    # print("{}".format(d.keys()))


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

    parsed = parse_mat(loadmat(test_path))
    format_dict(parsed)

    return parsed

def parse_cpp_file(fpointer):
    data = {}
    for line in fpointer.readlines():
        splits = line.split(",")  # Removes DT Entry
        for entry in splits:
            if "=" not in entry:
                continue
            key, value = entry.split("=")
            key = key.strip()
            if key not in data:
                data[key] = []
            data[key].append(float(value))
    format_dict(data)
    return data


def load_cpp(test_name):
    test_directory = os.path.join(os.path.dirname(os.path.abspath(__file__)), "dbs_on_gpu", "saved_tests", test_name)
    output_dir = os.path.join(test_directory, "output")
    data = {}
    for item in os.scandir(output_dir):
        with open(item.path, "r") as file:
            cell_data = parse_cpp_file(file)
            cell_type, cell_num = item.name.split("_NEURON_")
            cell_num = int(cell_num.split(".")[0] )
            if cell_type not in data:
                data[cell_type] = {}
            for k, v in cell_data.items():
                if k not in data[cell_type]:
                    data[cell_type][k] = {}
                data[cell_type][k][cell_num] = v
    return data


if __name__ == "__main__":
    for k, v in load_matlab("healthy_isolated_cells").items():
        print(k)
        # for k2 in v.keys():
        #     print(k2)
        # print()

    # for k, v in load_cpp("healthy_isolated_cells").items():
    #     print(k)
        # for k2 in v.keys():
        #     print(k2)
        # print()
    # print(load_matlab("healthy_isolated_cells").keys())
    print(load_cpp("healthy_isolated_cells"))