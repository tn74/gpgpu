function Out = syn_func_cor_d2(t_now,SynStrength,tau,CondDuration)

if nargin == 1
    SynStrength = 0.43/(5*exp(-1));
    tau = 5;
    CondDuration = 1000;
end

t_d_cor_d2=5.1;
Out = SynStrength*(t_now-t_d_cor_d2).*(exp(-(t_now-t_d_cor_d2)/tau)).*((t_now>=t_d_cor_d2)&(t_now<=CondDuration));

end