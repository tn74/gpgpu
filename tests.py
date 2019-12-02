import unittest
import ctypes
import dbs
import comparison


DBSC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbs.so")
TESTC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbstest.so")

class TestBasic(unittest.TestCase):
    """
    def test_run(self):
        TESTC.test_run()

    def test_run_from_python(self):
        sim_ptr = dbs.get_pointer(dbs.SimulationParameters, {"dt": 0.1, "duration": 10.0, "cells_per_type": 10})
        print(DBSC.execute_simulation(sim_ptr))
    def test_python_exec_sim(self):
        print(dbs.execute_simulation( {"dt": 0.1, "duration": 1.0, "cells_per_type": 2}))
    """
    def test_python(self):
        cudarr = dbs.execute_simulation( {"dt": 0.01, "duration": 1.0, "cells_per_type": 2})
        matarr = comparison.Loader().load_matlab("healthy_isolated_cells")
        print(matarr["TH"].keys())
        print(matarr["TH"]["VOLTAGE"][0])
        print(cudarr[0][0])

if __name__ == "__main__":
    unittest.main()

