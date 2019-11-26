import ctypes

DBSLIB = ctypes.CDLL("cudamodel/cmake-build-debug/libdbs.so")
# DBSLIB = ctypes.CDLL("cudamodel/build/libdbs.so")



def execute_main():
    print(DBSLIB.plain2())
    print(DBSLIB.addnum(3, 4))

if __name__ =="__main__":
    execute_main()