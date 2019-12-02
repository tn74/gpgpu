function Out = syn_func_th(t_now,SynStrength,tau,CondDuration)

if nargin == 1
    SynStrength = 0.43/(5*exp(-1));
    tau = 5;
    CondDuration = 1000;
end

t_d_th_cor=5; %transmission delay in the synapse
Out = SynStrength*(t_now-t_d_th_cor).*(exp(-(t_now-t_d_th_cor)/tau)).*((t_now>=t_d_th_cor)&(t_now<=CondDuration));

end