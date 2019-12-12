#include <stdio.h>
#include <math.h>
#include "gating.h"


#ifdef __CUDACC__
#define CUDA_HOSTDEV __host__ __device__
#else
#define CUDA_HOSTDEV
#endif

CUDA_HOSTDEV double gpe_ainf(double V)
{
  return 1/(1+exp(-(V+57)/2));
}

CUDA_HOSTDEV double gpe_hinf(double V)
{
  return 1/(1+exp((V+58)/12));
}

CUDA_HOSTDEV double gpe_minf(double V)
{
  return 1/(1+exp(-(V+37)/10));
}

CUDA_HOSTDEV double gpe_ninf(double V)
{
  return 1/(1+exp(-(V+50)/14));
}

CUDA_HOSTDEV double gpe_rinf(double V)
{
  return 1/(1+exp((V+70)/2));
}

CUDA_HOSTDEV double gpe_sinf(double V)
{
  return 1/(1+exp(-(V+35)/2));
}

CUDA_HOSTDEV double gpe_tauh(double V)
{
  return 0.05+0.27/(1+exp(-(V+40)/-12));
}

CUDA_HOSTDEV double gpe_taun(double V)
{
  return 0.05+0.27/(1+exp(-(V+40)/-12));
}

CUDA_HOSTDEV double Hinf(double V)
{
  return 1/(1+exp(-(V+57)/2));
}

CUDA_HOSTDEV double stn_ainf(double V)
{
  return 1/(1+exp(-(V+63)/7.8));
}

CUDA_HOSTDEV double stn_binf(double R)
{
  return 1/(1+exp(-(R-0.4)/0.1))-1/(1+exp(0.4/0.1));
}

CUDA_HOSTDEV double stn_cinf(double V)
{
  return 1/(1+exp(-(V+20)/8));
}

CUDA_HOSTDEV double stn_hinf(double V)
{
  return 1/(1+exp((V+39)/3.1));
}

CUDA_HOSTDEV double stn_minf(double V)
{
  return 1/(1+exp(-(V+30)/15));
}

CUDA_HOSTDEV double stn_ninf(double V)
{
  return 1/(1+exp(-(V+32)/8.0));
}

CUDA_HOSTDEV double stn_rinf(double V)
{
  return 1/(1+exp((V+67)/2));
}

CUDA_HOSTDEV double stn_sinf(double V)
{
  return 1/(1+exp(-(V+39)/8));
}

CUDA_HOSTDEV double stn_tauc(double V)
{
  return 1 + 10/(1+exp(-(V+80)/26));
}

CUDA_HOSTDEV double stn_tauh(double V)
{
  return 1 + 500/(1+exp(-(V+57)/-3));
}

CUDA_HOSTDEV double stn_taun(double V)
{
  return 1 + 100/(1+exp(-(V+80)/-26));
}

CUDA_HOSTDEV double stn_taur(double V)
{
  return 7.1 + 17.5/(1+exp(-(V-68)/-2.2));
}

CUDA_HOSTDEV double th_hinf(double V)
{
  return 1/(1+exp((V+41)/4));
}

CUDA_HOSTDEV double th_minf(double V)
{
  return 1/(1+exp(-(V+37)/7));
}

CUDA_HOSTDEV double th_pinf(double V)
{
  return 1/(1+exp(-(V+60)/6.2));
}

CUDA_HOSTDEV double th_rinf(double V)
{
  return 1/(1+exp((V+84)/4));
}

CUDA_HOSTDEV double ah(double V)
{
  return 0.128*exp(-(V+46)/18);
}

CUDA_HOSTDEV double bh(double V)
{
  return 4/(1+exp(-(V+23)/5));
}

CUDA_HOSTDEV double th_tauh(double V)
{
  return 1/(ah(V)+bh(V));
}

CUDA_HOSTDEV double th_taur(double V)
{
  return 0.15*(28+exp(-(V+25)/10.5));
}
