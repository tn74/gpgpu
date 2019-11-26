function Out = syn_func_stn_gpi(t_now,SynStrength,tau,CondDuration)

if nargin == 1
    SynStrength = 0.43/(5*exp(-1));
    tau = 5;
    CondDuration = 1000;
end

t_d_stn_gpi=1.5;
Out = SynStrength*(t_now-t_d_stn_gpi).*(exp(-(t_now-t_d_stn_gpi)/tau)).*((t_now>=t_d_stn_gpi)&(t_now<=CondDuration));

end