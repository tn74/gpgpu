import ctypes

DBSLIB = ctypes.CDLL("cudamodel/cmake-build-debug/libdbs.so")
# DBSLIB = ctypes.CDLL("cudamodel/build/libdbs.so")


def test_array_sum():
    arrlen = 10

    arr = (ctypes.c_int * arrlen)(*[i for i in range(arrlen)])
    return DBSLIB.arrsum(arr, arrlen)

def execute_main():
    print(DBSLIB.addnum(3, 4))
    print(test_array_sum())
    print(DBSLIB.cudatest())
if __name__ =="__main__":
    execute_main()
