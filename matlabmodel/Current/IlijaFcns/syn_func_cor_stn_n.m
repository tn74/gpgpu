function Out = syn_func_cor_stn_n(t_now,SynStrength,CondDuration)

if nargin == 1
    SynStrength = 0.43;
    CondDuration = 1000;
end

t_d_cor_stn=5.9;
taudn=90;
taurn=2;
tpeakn = t_d_cor_stn + (((taudn*taurn)/(taudn-taurn))*log(taudn/taurn)); 
fn = 1/(exp(-(tpeakn-t_d_cor_stn)/taudn)-exp(-(tpeakn-t_d_cor_stn)/taurn));
Out = SynStrength*fn*(t_now-t_d_cor_stn).*(exp(-(t_now-t_d_cor_stn)/taudn)-exp(-(t_now-t_d_cor_stn)/taurn)).*((t_now>=t_d_cor_stn)&(t_now<=CondDuration));

end