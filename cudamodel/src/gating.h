#ifndef GATING_FXNS
#define GATING_FXNS

#ifdef __CUDACC__
#define CUDA_HOSTDEV __host__ __device__
#else
#define CUDA_HOSTDEV
#endif

__device__ double gpe_ainf(double);
  __device__ double gpe_hinf(double);
  __device__ double gpe_minf(double);
  __device__ double gpe_ninf(double);
  __device__ double gpe_rinf(double);
  __device__ double gpe_sinf(double);
  __device__ double gpe_tauh(double);
  __device__ double gpe_taun(double);
  __device__ double Hinf(double);
  __device__ double stn_ainf(double);
  __device__ double stn_binf(double);
  __device__ double stn_cinf(double);
  __device__ double stn_hinf(double);
  __device__ double stn_minf(double);
  __device__ double stn_ninf(double);
  __device__ double stn_rinf(double);
  __device__ double stn_sinf(double);
  __device__ double stn_tauc(double);
  __device__ double stn_tauh(double);
  __device__ double stn_taun(double);
  __device__ double stn_taur(double);
  CUDA_HOSTDEV double th_hinf(double);
  __device__ double th_minf(double);
  __device__ double th_pinf(double);
  CUDA_HOSTDEV double th_rinf(double);
  __device__ double ah(double);
  __device__ double bh(double);
  __device__ double th_tauh(double);
  __device__ double th_taur(double);
#endif
