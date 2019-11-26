function Out = syn_func_gpi_th(t_now,SynStrength,tau,CondDuration)

if nargin == 1
    SynStrength = 0.3/(5*exp(-1));
    tau = 5;
    CondDuration = 1000;
end

t_d_gpi_th=5;
Out = SynStrength*(t_now-t_d_gpi_th).*(exp(-(t_now-t_d_gpi_th)/tau)).*((t_now>=t_d_gpi_th)&(t_now<=CondDuration));

end