#ifndef GATING_FXNS
#define GATING_FXNS

#ifdef __CUDACC__
#define CUDA_HOSTDEV __host__ __device__
#else
#define CUDA_HOSTDEV
#endif

CUDA_HOSTDEV double gpe_ainf(double);
CUDA_HOSTDEV double gpe_hinf(double);
CUDA_HOSTDEV double gpe_minf(double);
CUDA_HOSTDEV double gpe_ninf(double);
CUDA_HOSTDEV double gpe_rinf(double);
CUDA_HOSTDEV double gpe_sinf(double);
CUDA_HOSTDEV double gpe_tauh(double);
CUDA_HOSTDEV double gpe_taun(double);
CUDA_HOSTDEV double Hinf(double);
CUDA_HOSTDEV double stn_ainf(double);
CUDA_HOSTDEV double stn_binf(double);
CUDA_HOSTDEV double stn_cinf(double);
CUDA_HOSTDEV double stn_hinf(double);
CUDA_HOSTDEV double stn_minf(double);
CUDA_HOSTDEV double stn_ninf(double);
CUDA_HOSTDEV double stn_rinf(double);
CUDA_HOSTDEV double stn_sinf(double);
CUDA_HOSTDEV double stn_tauc(double);
CUDA_HOSTDEV double stn_tauh(double);
CUDA_HOSTDEV double stn_taun(double);
CUDA_HOSTDEV double stn_taur(double);
CUDA_HOSTDEV double th_hinf(double);
CUDA_HOSTDEV double th_minf(double);
CUDA_HOSTDEV double th_pinf(double);
CUDA_HOSTDEV double th_rinf(double);
CUDA_HOSTDEV double ah(double);
CUDA_HOSTDEV double bh(double);
CUDA_HOSTDEV double th_tauh(double);
CUDA_HOSTDEV double th_taur(double);
#endif
