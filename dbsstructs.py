import ctypes

class SimulationParameters(ctypes.Structure):
   _fields_ = [
        ("dt", ctypes.c_double),
        ("duration", ctypes.c_double),
        ("cells_per_type", ctypes.c_int)
    ]

class THState(ctypes.Structure):
    _fields_ = [
        ("voltage",  ctypes.c_double),
        ("I_L",      ctypes.c_double),
        ("I_Na",     ctypes.c_double),
        ("I_K",      ctypes.c_double),
        ("I_T",      ctypes.c_double),
        ("H",        ctypes.c_double),
        ("R",        ctypes.c_double),
    ]


class STNState(ctypes.Structure):
    _fields_ = [
        ("voltage",  ctypes.c_double),
        ("I_Na",      ctypes.c_double),
        ("I_L",     ctypes.c_double),
        ("I_K",      ctypes.c_double),
        ("I_T",      ctypes.c_double),
        ("I_Ca",      ctypes.c_double),
        ("I_ahp",      ctypes.c_double),
        ("H",        ctypes.c_double),
        ("R",        ctypes.c_double),
        ("N",        ctypes.c_double),
        ("C",        ctypes.c_double),
        ("CA",        ctypes.c_double),
    ]
