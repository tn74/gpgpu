function Out = syn_func_str_indr(t_now,SynStrength,tau,CondDuration)

if nargin == 1
    SynStrength = 0.3/(5*exp(-1));
    tau = 5;
    CondDuration = 1000;
end

t_d_d2_gpe=5;
Out = SynStrength*(t_now- t_d_d2_gpe).*(exp(-(t_now-t_d_d2_gpe)/tau)).*((t_now>=t_d_d2_gpe)&(t_now<=CondDuration));

end