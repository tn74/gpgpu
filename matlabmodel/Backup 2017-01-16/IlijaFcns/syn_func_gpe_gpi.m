function Out = syn_func_gpe_gpi(t_now,SynStrength,tau,CondDuration)

if nargin == 1
    SynStrength = 0.3/(5*exp(-1));
    tau = 5;
    CondDuration = 1000;
end

t_d_gpe_gpi=3;
Out = SynStrength*(t_now-t_d_gpe_gpi).*(exp(-(t_now-t_d_gpe_gpi)/tau)).*((t_now>=t_d_gpe_gpi)&(t_now<=CondDuration));

end