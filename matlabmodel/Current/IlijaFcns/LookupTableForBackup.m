%TH-CTX Synapse
t_d_th_cor=5; %transmission delay in the synapse
syn_func_th = const*(t_vec-t_d_th_cor).*(exp(-(t_vec-t_d_th_cor)/tau)).*((t_vec>=t_d_th_cor)&(t_vec<=t_a)); %look at paper, pg5, section 2.1 (eq 1)

%STN-GPe Synapse
t_d_stn_gpe=2;
taudstngpea=2.5;
taurstngpea=0.4;
taudstngpen=67;
taurstngpen=2;
tpeakstngpea = t_d_stn_gpe + (((taudstngpea*taurstngpea)/(taudstngpea-taurstngpea))*log(taudstngpea/taurstngpea)); 
fstngpea = 1/(exp(-(tpeakstngpea-t_d_stn_gpe)/taudstngpea)-exp(-(tpeakstngpea-t_d_stn_gpe)/taurstngpea));
syn_func_stn_gpea = gpeak*fstngpea*(t_vec-t_d_stn_gpe).*(exp(-(t_vec-t_d_stn_gpe)/taudstngpea)-exp(-(t_vec-t_d_stn_gpe)/taurstngpea)).*((t_vec>=t_d_stn_gpe)&(t_vec<=t_a));
tpeakstngpen = t_d_stn_gpe + (((taudstngpen*taurstngpen)/(taudstngpen-taurstngpen))*log(taudstngpen/taurstngpen)); 
fstngpen = 1/(exp(-(tpeakstngpen-t_d_stn_gpe)/taudstngpen)-exp(-(tpeakstngpen-t_d_stn_gpe)/taurstngpen));
syn_func_stn_gpen = gpeak*fstngpen*(t_vec-t_d_stn_gpe).*(exp(-(t_vec-t_d_stn_gpe)/taudstngpen)-exp(-(t_vec-t_d_stn_gpe)/taurstngpen)).*((t_vec>=t_d_stn_gpe)&(t_vec<=t_a));

%STN-GPi Synapse
t_d_stn_gpi=1.5;
syn_func_stn_gpi = const*(t_vec-t_d_stn_gpi).*(exp(-(t_vec-t_d_stn_gpi)/tau)).*((t_vec>=t_d_stn_gpi)&(t_vec<=t_a));

%GPe-STN Synapse
t_d_gpe_stn=4;
taudg=7.7;
taurg=0.4;
tpeakg = t_d_gpe_stn + (((taudg*taurg)/(taudg-taurg))*log(taudg/taurg)); 
fg = 1/(exp(-(tpeakg-t_d_gpe_stn)/taudg)-exp(-(tpeakg-t_d_gpe_stn)/taurg));
syn_func_gpe_stn = gpeak1*fg*(t_vec-t_d_gpe_stn).*(exp(-(t_vec-t_d_gpe_stn)/taudg)-exp(-(t_vec-t_d_gpe_stn)/taurg)).*((t_vec>=t_d_gpe_stn)&(t_vec<=t_a));

%GPe-GPi Synapse
t_d_gpe_gpi=3;
syn_func_gpe_gpi = const1*(t_vec-t_d_gpe_gpi).*(exp(-(t_vec-t_d_gpe_gpi)/tau)).*((t_vec>=t_d_gpe_gpi)&(t_vec<=t_a));

%GPe-GPe Synapse
t_d_gpe_gpe=1;
syn_func_gpe_gpe = const1*(t_vec-t_d_gpe_gpe).*(exp(-(t_vec-t_d_gpe_gpe)/tau)).*((t_vec>=t_d_gpe_gpe)&(t_vec<=t_a));

%GPi-TH Synapse
t_d_gpi_th=5;
syn_func_gpi_th = const1*(t_vec-t_d_gpi_th).*(exp(-(t_vec-t_d_gpi_th)/tau)).*((t_vec>=t_d_gpi_th)&(t_vec<=t_a));

%Indirect Str-GPe Synapse
t_d_d2_gpe=5;
syn_func_str_indr = const2*(t_vec- t_d_d2_gpe).*(exp(-(t_vec-t_d_d2_gpe)/tau)).*((t_vec>=t_d_d2_gpe)&(t_vec<=t_a));

%direct Str-GPi Synapse
t_d_d1_gpi=4;
syn_func_str_dr = const2*(t_vec- t_d_d1_gpi).*(exp(-(t_vec-t_d_d1_gpi)/tau)).*((t_vec>=t_d_d1_gpi)&(t_vec<=t_a));

%Cortex-Indirect Str Synapse
t_d_cor_d2=5.1;
syn_func_cor_d2 = const*(t_vec-t_d_cor_d2).*(exp(-(t_vec-t_d_cor_d2)/tau)).*((t_vec>=t_d_cor_d2)&(t_vec<=t_a));
 
%Cortex-STN Synapse
t_d_cor_stn=5.9;
taudn=90;
taurn=2;
tauda=2.49;
taura=0.5;
tpeaka = t_d_cor_stn + (((tauda*taura)/(tauda-taura))*log(tauda/taura)); 
fa = 1/(exp(-(tpeaka-t_d_cor_stn)/tauda)-exp(-(tpeaka-t_d_cor_stn)/taura));
syn_func_cor_stn_a = gpeak*fa*(t_vec-t_d_cor_stn).*(exp(-(t_vec-t_d_cor_stn)/tauda)-exp(-(t_vec-t_d_cor_stn)/taura)).*((t_vec>=t_d_cor_stn)&(t_vec<=t_a));
tpeakn = t_d_cor_stn + (((taudn*taurn)/(taudn-taurn))*log(taudn/taurn)); 
fn = 1/(exp(-(tpeakn-t_d_cor_stn)/taudn)-exp(-(tpeakn-t_d_cor_stn)/taurn));
syn_func_cor_stn_n = gpeak*fn*(t_vec-t_d_cor_stn).*(exp(-(t_vec-t_d_cor_stn)/taudn)-exp(-(t_vec-t_d_cor_stn)/taurn)).*((t_vec>=t_d_cor_stn)&(t_vec<=t_a));