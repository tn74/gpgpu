from scipy.io import loadmat
import os
from shutil import copytree


def save_matlab(test_name):
    basepath = os.path.dirname(os.path.abspath(__file__))
    out_path =os.path.join(basepath, "saved_tests", test_name)
    copytree(os.path.join(basepath, "saveddata"), out_path)


def load_test_data(test_name):
    basepath = os.path.dirname(os.path.abspath(__file__))
    test_path = os.path.join(basepath, "saved_tests", test_name)

    for mat_fname in os.listdir(test_path):
        mat_path = os.path.join(test_path, mat_fname)
        if ".mat" not in mat_path:
            continue
        data = loadmat(mat_path)
        print(data)


if __name__ == "__main__":
    # save_matlab("test1")
    load_test_data(("test1"))