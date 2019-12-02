function Out = syn_func_cor_stn_a(t_now,SynStrength,CondDuration)

if nargin == 1
    SynStrength = 0.43;
    CondDuration = 1000;
end

t_d_cor_stn=5.9;
tauda=2.49;
taura=0.5;
tpeaka = t_d_cor_stn + (((tauda*taura)/(tauda-taura))*log(tauda/taura)); 
fa = 1/(exp(-(tpeaka-t_d_cor_stn)/tauda)-exp(-(tpeaka-t_d_cor_stn)/taura));
Out = SynStrength*fa*(t_now-t_d_cor_stn).*(exp(-(t_now-t_d_cor_stn)/tauda)-exp(-(t_now-t_d_cor_stn)/taura)).*((t_now>=t_d_cor_stn)&(t_now<=CondDuration));

end