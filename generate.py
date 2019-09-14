class CGenerator:

    SRC_DIR = "~/Documents/Duke/s6/ece590/gpgpu/dbs_on_gpu/src"

    def generate_struct(self, param_map):
        struct_str = "typedef struct parameter_map {"
        for k, v in param_map.items():
            struct_str +=  f"\n\tdouble {k};"
        struct_str += "\n} parameter_map_t;"
        return struct_str

    def write(self):


if __name__ == "__main__":
    th_param = {}
    th_param["C_m"] = 1.0
    th_param["g_L"] = 0.0
    th_param["E_L"] = -70
    th_param["g_Na"] = 3.0
    th_param["E_Na"] = 50.0
    th_param["g_K"] = 5.0
    th_param["E_K"] = -75.0
    th_param["g_T"] = 5.0
    th_param["E_T"] = 0.0
    print(generate_struct(th_param))
#    stn_param["C_m"] = 1.0;
#    stn_param["g_L"] = 2.25;
#    stn_param["E_L"] = -60.0;
#    stn_param["g_Na"] = 37.0;
#    stn_param["E_Na"] = 55.0;
#    stn_param["g_K"] = 45.0;
#    stn_param["E_K"] = -80.0;
#    stn_param["g_T"] = 0.5;
#    stn_param["E_T"] = 0.0;
#    stn_param["g_Ca"] = 2.0;
#    stn_param["E_Ca"] = 140.0;
#    stn_param["g_ahp"] = 20.0;
#    stn_param["E_ahp"] = -80.0;
#
#    gpe_param["C_m"] = 1.0;
#    gpe_param["g_L"] = 0.1;
#    gpe_param["E_L"] = -65.0;
#    gpe_param["g_Na"] = 120.0;
#    gpe_param["E_Na"] = 55.0;
#    gpe_param["g_K"] = 30.0;
#    gpe_param["E_K"] = -80.0;
#    gpe_param["g_T"] = 0.5;
#    gpe_param["E_T"] = 0.0;
#    gpe_param["g_Ca"] = 0.15;
#    gpe_param["E_Ca"] = 120.0;
#    gpe_param["g_ahp"] = 10.0;
#    gpe_param["E_ahp"] = -80.0;
#
#
#    gpi_param["C_m"] = 1.0;
#    gpi_param["g_L"] = 0.1;
#    gpi_param["E_L"] = -65.0;
#    gpi_param["g_Na"] = 120.0;
#    gpi_param["E_Na"] = 55.0;
#    gpi_param["g_K"] = 30.0;
#    gpi_param["E_K"] = -80.0;
#    gpi_param["g_T"] = 0.5;
#    gpi_param["E_T"] = 0.0;
#    gpi_param["g_Ca"] = 0.15;
#    gpi_param["E_Ca"] = 120.0;
#    gpi_param["g_ahp"] = 10.0;
#    gpi_param["E_ahp"] = -80.0;
