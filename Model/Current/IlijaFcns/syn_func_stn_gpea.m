function Out = syn_func_stn_gpea(t_now,SynStrength,CondDuration)

if nargin == 1
    SynStrength = 0.43;
    CondDuration = 1000;
end

t_d_stn_gpe=2;
taudstngpea=2.5;
taurstngpea=0.4;
tpeakstngpea = t_d_stn_gpe + (((taudstngpea*taurstngpea)/(taudstngpea-taurstngpea))*log(taudstngpea/taurstngpea)); 
fstngpea = 1/(exp(-(tpeakstngpea-t_d_stn_gpe)/taudstngpea)-exp(-(tpeakstngpea-t_d_stn_gpe)/taurstngpea));
Out = SynStrength*fstngpea*(t_now-t_d_stn_gpe).*(exp(-(t_now-t_d_stn_gpe)/taudstngpea)-exp(-(t_now-t_d_stn_gpe)/taurstngpea)).*((t_now>=t_d_stn_gpe)&(t_now<=CondDuration));

end