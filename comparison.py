from scipy.io import loadmat
import os
import numpy as np
from matplotlib import pyplot as plt


class Loader():

    def format_dict(self, d):
        current_keys = list(d.keys())
        for k in current_keys:
            if type(d[k]) == dict:
                self.format_dict(d[k])
            d[k.upper().replace("_", "")] = d.pop(k)
        # print("{}".format(d.keys()))

    def get_cell_type(self, key_string):
        if key_string.startswith(("th_", "stn_", "gpe_", "gpi_")):
            return key_string.split("_")[0]
        return None

    def parse_mat(self, matfile):
        parsed_data = {"th": {}, "stn": {}, "gpe": {}, "gpi": {}}
        for key, value in matfile.items():
            cell_type = self.get_cell_type(key)
            if cell_type is None:
                continue
            debug_val = key.split("_")[1]
            parsed_data[cell_type][debug_val] = value
        return parsed_data

    def load_matlab(self, test_name):
        basepath = os.path.dirname(os.path.abspath(__file__))
        test_path = os.path.join(basepath, "matlabmodel", "BGNetwork", "saved_tests", "{}.mat".format(test_name))

        parsed = self.parse_mat(loadmat(test_path))
        self.format_dict(parsed)

        return parsed

    def parse_cpp_file(self, fpointer):
        data = {}
        for i, line in enumerate(fpointer.readlines()):
            splits = line.split(",")  # Removes DT Entry
            for entry in splits:
                if "=" not in entry:
                    continue
                key, value = entry.split("=")
                key = key.strip()
                if key not in data:
                    data[key] = [0 for c in range(i)]  # Fill 0s for previous empty lines
                data[key].append(float(value))
        self.format_dict(data)
        return data

    def load_cpp(self, output_dir):
        data = {}
        for item in os.scandir(output_dir):
            with open(item.path, "r") as file:
                cell_data = self.parse_cpp_file(file)
                cell_type, cell_num = item.name.split("_NEURON_")
                cell_num = int(cell_num.split(".")[0])
                if cell_type not in data:
                    data[cell_type] = {}
                for k, v in cell_data.items():
                    if k not in data[cell_type]:
                        data[cell_type][k] = {}
                    data[cell_type][k][cell_num] = v
        for cell_type in data.keys():
            for property in data[cell_type]:
                data[cell_type][property] = np.array(list(data[cell_type][property].values()))

        return data


class Comparator:

    def plot_voltages(self, m, c):
        fig, axes = plt.subplots(4, 2)
        fig.suptitle("Matlab vs GPGPU Model")
        plt.xlabel("ms")
        for i, cell_type in enumerate(m.keys()):
            voltage = m[cell_type]['VOLTAGE'][0]
            x = np.linspace(0, 0.01 * len(voltage), len(voltage))
            axes[i, 0].plot(x, voltage)
            if cell_type in c:
                voltage = c[cell_type]['VOLTAGE'][0]
                x = np.linspace(0, 0.01 * len(voltage), len(voltage))
                axes[i, 1].plot(x, voltage)
        plt.show()

    def see_differences(self, mc, cc, print_range=(0, 5)):
        for property, values in mc.items():
            if property in cc.keys():
                print("Property = {}".format(property))
                start, finish = print_range
                for i in range(start, finish):
                    print("{:5d} | {:.2e} ms | {} | Matlab = {:.3e} | C++ = {:.3e}".format(
                        i, i*0.01, property, mc[property][0][i], cc[property][0][i]))
                print()

    def plot_voltage_differential(self, m, c):
        fig, axes = plt.subplots(4,1, figsize=(6,12))
        fig.suptitle("Voltage Differentials")
        for type_index, cell_type in enumerate(m.keys()):
            m_voltage = m[cell_type]["VOLTAGE"]
            c_voltage = c[cell_type]["VOLTAGE"][1:2]
            for cell_index in range(min(len(m_voltage), len(c_voltage))):
                display_length = len(c_voltage[cell_index])
                x = np.linspace(0, 0.01 * len(m_voltage[0]), len(m_voltage[0]))[:display_length]
                difference = m_voltage[cell_index][:display_length] - c_voltage[cell_index]
                axes[type_index].plot(x, difference, label="Cell {}".format(cell_index))
                axes[type_index].set_title(cell_type)
        plt.savefig("differentials.png")


if __name__ == "__main__":
    loader = Loader()
    m, c = loader.load_matlab("healthy_isolated_cells"), loader.load_cpp("healthy_isolated_cells")
    comparator = Comparator()
    comparator.see_differences(m["STN"], c["STN"], print_range=(0, 10))
    # comparator.plot_voltages(m, c)
    comparator.plot_voltage_differential(m, c)
