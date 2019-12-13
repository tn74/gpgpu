import ctypes
import time
import unittest
import comparison
import json

LOADER = comparison.Loader()


class TestBasic(unittest.TestCase):

    def test_TH(self):
        matlab = LOADER.load_matlab("healthy_isolated_cells")
        cuda = LOADER.load_cpp("cudamodel/saved_tests/basic2")
        thresh = 1e-5
        for i in range(1, len(cuda["TH"]["VOLTAGE"])):
            assert abs(cuda["TH"]["VOLTAGE"][0][i] - matlab["TH"]["VOLTAGE"][0][i]) < thresh

    def test_STN(self):
        matlab = LOADER.load_matlab("healthy_isolated_cells")
        cuda = LOADER.load_cpp("cudamodel/saved_tests/basic2")
        thresh = 1e-5
        for i in range(1, len(cuda["TH"]["VOLTAGE"])):
            assert abs(cuda["STN"]["VOLTAGE"][0][i] - matlab["STN"]["VOLTAGE"][0][i]) < thresh

    def test_GPE(self):
        matlab = LOADER.load_matlab("healthy_isolated_cells")
        cuda = LOADER.load_cpp("cudamodel/saved_tests/basic2")
        thresh = 1e-5
        for i in range(1, len(cuda["TH"]["VOLTAGE"])):
            assert abs(cuda["GPE"]["VOLTAGE"][0][i] - matlab["GPE"]["VOLTAGE"][0][i]) < thresh
if __name__ == "__main__":
    unittest.main()

