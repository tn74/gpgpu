import unittest
import ctypes

DBSC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbs.so")
TESTC = ctypes.CDLL("cudamodel/cmake-build-debug/libdbstest.so")

class TestBasic(unittest.TestCase):
    def test_run(self):
        self.assertEqual(TESTC.test_run(), 0)




if __name__ == "__main__":
    unittest.main()

