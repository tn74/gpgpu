import ctypes

DBSLIB = ctypes.CDLL("cudamodel/cmake-build-debug/libdbs.so")


def execute_main():
    print(DBSLIB.main())
    print(DBSLIB.plain2())

if __name__ =="__main__":
    execute_main()