function Out = syn_func_stn_gpen(t_now,SynStrength,CondDuration)

if nargin == 1
    SynStrength = 0.43;
    CondDuration = 1000;
end

t_d_stn_gpe=2;
taudstngpen=67;
taurstngpen=2;
tpeakstngpen = t_d_stn_gpe + (((taudstngpen*taurstngpen)/(taudstngpen-taurstngpen))*log(taudstngpen/taurstngpen)); 
fstngpen = 1/(exp(-(tpeakstngpen-t_d_stn_gpe)/taudstngpen)-exp(-(tpeakstngpen-t_d_stn_gpe)/taurstngpen));
Out = SynStrength*fstngpen*(t_now-t_d_stn_gpe).*(exp(-(t_now-t_d_stn_gpe)/taudstngpen)-exp(-(t_now-t_d_stn_gpe)/taurstngpen)).*((t_now>=t_d_stn_gpe)&(t_now<=CondDuration));

end