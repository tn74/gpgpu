import unittest
import ctypes
import dbs
import comparison
import time
import json
import os

DBSC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbs.so")
TESTC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbstest.so")

class TestBasic(unittest.TestCase):
    """
    def test_C_run(self):
        TESTC.test_run()

    def test_generate_simulation_ptr(self):
        sim_ptr = dbs.get_pointer(dbs.SimulationParameters, {"dt": 0.1, "duration": 10.0, "cells_per_type": 10})

    def test_python_exec_sim_debug(self):
        dbs.execute_simulation_debug({"dt": 0.1, "duration": 1.0, "cells_per_type": 2})
    """
    def test_th_healthy(self):
        dt, dur = 0.01, 1.0
        timesteps = int(dur/dt)
        cudamap = dbs.execute_simulation_debug( {"dt": dt, "duration": dur, "cells_per_type": 2})
        matarr = comparison.Loader().load_matlab("healthy_isolated_cells")
        thresh = 1e-3
        for i in range(timesteps):
            assert (cudamap["TH"]["VOLTAGE"][0][i] - matarr["TH"]["VOLTAGE"][0][i]) < thresh
            assert (cudamap["STN"]["VOLTAGE"][0][i] -  matarr["STN"]["VOLTAGE"][0][i]) < thresh
class GeneratePython(unittest.TestCase):
    def test_healthy(self):
        dbs.execute_simulation_debug( {"dt": 0.01, "duration": 1.0, "cells_per_type": 2})
        #os.system("mv cudamodel/cmake-build-debug/output cudamodel/saved_tests/hey")
if __name__ == "__main__":
    unittest.main()

