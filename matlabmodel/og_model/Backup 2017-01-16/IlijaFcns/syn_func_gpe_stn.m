function Out = syn_func_gpe_stn(t_now,SynStrength,CondDuration)

if nargin == 1
    SynStrength = 0.3;
    CondDuration = 1000;
end

t_d_gpe_stn=4;
taudg=7.7;
taurg=0.4;
tpeakg = t_d_gpe_stn + (((taudg*taurg)/(taudg-taurg))*log(taudg/taurg)); 
fg = 1/(exp(-(tpeakg-t_d_gpe_stn)/taudg)-exp(-(tpeakg-t_d_gpe_stn)/taurg));
Out = SynStrength*fg*(t_now-t_d_gpe_stn).*(exp(-(t_now-t_d_gpe_stn)/taudg)-exp(-(t_now-t_d_gpe_stn)/taurg)).*((t_now>=t_d_gpe_stn)&(t_now<=CondDuration));

end