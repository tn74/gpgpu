import unittest
import ctypes
import dbs

DBSC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbs.so")
TESTC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbstest.so")

class TestBasic(unittest.TestCase):
    """
    def test_run(self):
        TESTC.test_run()

    def test_run_from_python(self):
        sim_ptr = dbs.get_pointer(dbs.SimulationParameters, {"dt": 0.1, "duration": 10.0, "cells_per_type": 10})
        print(DBSC.execute_simulation(sim_ptr))
    """
    def test_python_exec_sim(self):
        print(dbs.execute_simulation( {"dt": 0.1, "duration": 1.0, "cells_per_type": 2}))

if __name__ == "__main__":
    unittest.main()

