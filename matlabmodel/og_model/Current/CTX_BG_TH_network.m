function [TH_APs STN_APs GPe_APs GPi_APs Striat_APs_indr Striat_APs_dr Cor_APs vth VoltValsGPi InpsGPi OutsGPi InpsTH OutsTH OutsVTH] = CTX_BG_TH_network(pd,tmax,dt,n,Idbs)

%rng(666);

% Description:
%   Models behaviour of the brain.
% Inputs:
%   pd: 0(normal/healthy condition), 1(Parkinson's disease(PD) condition)
%   tmax: Duration of the simulation
%   dt: Time resolution of the simulation
%   n: number of neurons in each nucleus
%   Idbs: Deep Brain Stimulation Current
% Outputs:
%   TH_APs: Thalamic Action Potentials (TH)
%   STN_APs: Subthalamic Nucleus Action Potentials (STN)
%   GPe_APs: Globus Pallidus Externa Action Potentials (GPe)
%   GPi_APs: Globus Pallidus Interna Action Potentials (GPi)
%   Striat_APs_indr: Striatal neurons Action Potentials indirect(idStr)
%   Striat_APs_dr: Striatal neurons Action Potentials direct(dStr)
%   Cor_APs: Cortical Action Potentials
   
    %time step
    t=0:dt:tmax;

    %initial conditions (IC) to the different cell types
    v1=-62+randn(n,1)*5;  %TH  % normal distribution with mean = -62/-63.8 and SD = 5
    v2=-62+randn(n,1)*5;    %STN
    v3=-62+randn(n,1)*5;    %GPe
    v4=-62+randn(n,1)*5;    %GPi
    v5=-63.8+randn(n,1)*5;  %STRind
    v6=-63.8+randn(n,1)*5;  %STNdr

% IC-Excitatory Regular Spiking Neurons -rCortex
ae=0.02;
be=0.2;
ce=-65;
de=8;

% IC-Inhibitory Fast Spiking InterNeurons -iCortex
ai=0.1;
bi=0.2;
ci=-65;
di=2;



Cm=1; %Membrane capacitance


%Ionic conductance and Equilibrium potential values
%Provided in Appendix A
gl=[0.05 0.35 0.1 0.1]; El=[-70 -60 -65 -67];
gna=[3 49 120 100]; Ena=[50 60 55 50]; 
gk=[5 57 30 80]; Ek=[-75 -90 -80 -100];
gt=[5 5 0.5]; Et=0;
gca=[0 2 0.15]; Eca=[0 140 120];
Em=-100; 
gahp=[0 20 10]; k1=[0 15 10]; kca=[0 22.5 15];
ga=5;
gL=15;
gcak=1;

Kca=2*10^-3;
Z=2;
F=96485;
CAsn2=0.005*ones(n,1);
Cao=2000;
R=8314;
T=298;

alp=1/(Z*F);
con=(R*T)/(Z*F);




%%Setting initial matrices
vth=zeros(n,length(t)); %thalamic membrane voltage
vsn=zeros(n,length(t)); %STN membrane voltage
vge=zeros(n,length(t)); %GPe membrane voltage
vgi=zeros(n,length(t)); %GPi membrane voltage
vstr_indr=zeros(n,length(t)); %Indirect Striatum membrane voltage
vstr_dr=zeros(n,length(t)); %Direct Striatum membrane voltage
ve=zeros(n,length(t)); %Excitatory Cortex membrane voltage
vi=zeros(n,length(t)); %Inhibitory Cortex membrane voltage
ue=zeros(n,length(t)); %Cortex is governed by different model
ui=zeros(n,length(t));  %Check Appendix_A



%%initial conditions
vth(:,1)=v1;
vsn(:,1)=v2;
vge(:,1)=v3;
vgi(:,1)=v4;
vstr_indr(:,1)=v5;
vstr_dr(:,1)=v6;
ve(:,1)=ce;
ue(:,1)=be*ve(1);
vi(:,1)=ci;
ui(:,1)=bi*vi(1);

% State variables 
N3=gpe_ninf(vge(:,1));N4=gpe_ninf(vgi(:,1)); %taking probability values from [0,1]
H1=th_hinf(vth(:,1)); 
H3=gpe_hinf(vge(:,1));H4=gpe_hinf(vgi(:,1));
R1=th_rinf(vth(:,1)); 
R3=gpe_rinf(vge(:,1));R4=gpe_rinf(vgi(:,1));
CA2=0.1; 
CA3=CA2;CA4=CA2; 

N2=stn_ninf(vsn(:,1));
H2=stn_hinf(vsn(:,1));
M2=stn_minf(vsn(:,1));
A2=stn_ainf(vsn(:,1));
B2=stn_binf(vsn(:,1));
C2=stn_cinf(vsn(:,1));
D2=stn_d2inf(vsn(:,1));
D1=stn_d1inf(vsn(:,1));
P2=stn_pinf(vsn(:,1));
Q2=stn_qinf(vsn(:,1));
R2=stn_rinf(vsn(:,1));

m5=alpham(vstr_indr(:,1))./(alpham(vstr_indr(:,1))+betam(vstr_indr(:,1)));
h5=alphah(vstr_indr(:,1))./(alphah(vstr_indr(:,1))+betah(vstr_indr(:,1)));
n5=alphan(vstr_indr(:,1))./(alphan(vstr_indr(:,1))+betan(vstr_indr(:,1)));
p5=alphap(vstr_indr(:,1))./(alphap(vstr_indr(:,1))+betap(vstr_indr(:,1)));
m6=alpham(vstr_dr(:,1))./(alpham(vstr_dr(:,1))+betam(vstr_dr(:,1)));
h6=alphah(vstr_dr(:,1))./(alphah(vstr_dr(:,1))+betah(vstr_dr(:,1)));
n6=alphan(vstr_dr(:,1))./(alphan(vstr_dr(:,1))+betan(vstr_dr(:,1)));
p6=alphap(vstr_dr(:,1))./(alphap(vstr_dr(:,1))+betap(vstr_dr(:,1))); 

%%Synapse parameters
gsyn = [1 0.3 1 0.3 1 .08]; Esyn = [-85 0 -85 0 -85 -85 -80];
tau=5; tau_i=13; gpeak=0.43; gpeak1=0.3; 

S2a=zeros(n,1); %ctrl+f ILIJA
S21a=zeros(n,1); 
S2b=zeros(n,1); 
S21b=zeros(n,1); 
S2an=zeros(n,1); 
S21an=zeros(n,1); 
S3a=zeros(n,1); 
S31a=zeros(n,1); 
% S32a=zeros(n,1); 
% S33a=zeros(n,1); 
% S34a=zeros(n,1); 
% S35a=zeros(n,1); 
% S36a=zeros(n,1); 
% S37a=zeros(n,1); 
% S38a=zeros(n,1); 
% S39a=zeros(n,1); 
S3b=zeros(n,1);
S31b=zeros(n,1);
S32b=zeros(n,1);
S3c=zeros(n,1);
S31c=zeros(n,1); 
S32c=zeros(n,1); 
S33c=zeros(n,1); 
S34c=zeros(n,1); 
S4=zeros(n,1); 
S5=zeros(n,1);
S51=zeros(n,1);
S52=zeros(n,1);
S53=zeros(n,1);
S54=zeros(n,1);
S55=zeros(n,1);
S56=zeros(n,1);
S57=zeros(n,1);
S58=zeros(n,1);
S59=zeros(n,1);
S9=zeros(n,1);
S6a=zeros(n,1);
S6b=zeros(n,1);
S6bn=zeros(n,1);
S61bn=zeros(n,1);
S61b=zeros(n,1);
S62b=zeros(n,1);
S63b=zeros(n,1);
S64b=zeros(n,1);
S65b=zeros(n,1);
S66b=zeros(n,1);
S67b=zeros(n,1);
S68b=zeros(n,1);
S69b=zeros(n,1);
S91=zeros(n,1);
S92=zeros(n,1);
S93=zeros(n,1);
S94=zeros(n,1);
S95=zeros(n,1);
S96=zeros(n,1);
S97=zeros(n,1);
S98=zeros(n,1);
S99=zeros(n,1);
S7=zeros(n,1);
S8=zeros(n,1);
S1a=zeros(n,1); 
S1b=zeros(n,1); 
S1c=zeros(n,1); 
Z1a=zeros(n,1);
Z1b=zeros(n,1);

t_a = 1000; % Max duration of syn conductance
t_vec = 0:dt:t_a;
const = gpeak/(tau*exp(-1));
const1 = gpeak1/(tau*exp(-1)); 
const2 = gpeak1/(tau*exp(-1)); 

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
% times when these synapses get activated (from their respective brain
% structures). Gets updated during iterations.
t_list_th(1:n) = struct('times',[]);
t_list_cor(1:n) = struct('times',[]);
t_list_str_indr(1:n) = struct('times',[]);
t_list_str_dr(1:n) = struct('times',[]);
t_list_stn(1:n) = struct('times',[]);
t_list_gpe(1:n) = struct('times',[]);
t_list_gpi(1:n) = struct('times',[]);

%cortex and Str (only these are done randomly)
%ILIJA: cortex and Str - how to choose random nerons for synapses
%connection
all=randsample(n,n);
bll=randsample(n,n);
cll=randsample(n,n);
dll=randsample(n,n);
ell=randsample(n,n);
fll=randsample(n,n);
gll=randsample(n,n);
hll=randsample(n,n);
ill=randsample(n,n);
jll=randsample(n,n);
kll=randsample(n,n);
lll=randsample(n,n);
mll=randsample(n,n);
nll=randsample(n,n);
oll=randsample(n,n);

gcorsna=0.15*rand(n,1);
gcorsnn=0.003*rand(n,1);
gcordrstr=(0.07-0.044*pd)+0.001*rand(n,1);
ggege=1*rand(n,1);


gsngen=zeros(n,1);
gsngen(randperm(10,2)')=0.002*rand(2,1);
gsngea=zeros(n,1);
gsngea(randperm(10,2)')=0.3*rand(2,1);
gsngi=zeros(n,1);
gsngi(randperm(10,5)')=0.15;
ggith=0.112;
ggesn=0.5;
gstrgpe=0.5;
gstrgpi=0.5;
ggigi=0.5;
gm=1;
ggaba=0.1;
gcorindrstr=0.07;
gie=0.2;
gthcor=0.15;
gei=0.1;

%All starting values set, starting the simulation

       
    for i=2:length(t)  
        
        V1=vth(:,i-1);   
        V2=vsn(:,i-1);     
        V3=vge(:,i-1);    
        V4=vgi(:,i-1);
        V5=vstr_indr(:,i-1);
        V6=vstr_dr(:,i-1);
        V7=ve(:,i-1);
        V8=vi(:,i-1);

    % Synapse parameters 
    
    S21a(2:n)=S2a(1:n-1); %All these S-s show from which neurons the target neuron is receiving inputs (ILIJA)
    S21a(1)=S2a(n);
    
    S21an(2:n)=S2an(1:n-1);
    S21an(1)=S2an(n);
    
    S21b(2:n)=S2b(1:n-1);
    S21b(1)=S2b(n);

    S31a(1:n-1)=S3a(2:n);
    S31a(n)=S3a(1);
%     S32a(1:n-2)=S3a(3:n);
%     S32a(n-1:n)=S3a(1:2);
%     S33a(1:n-3)=S3a(4:n);
%     S33a(n-2:n)=S3a(1:3);
%     S34a(1:n-4)=S3a(5:n);
%     S34a(n-3:n)=S3a(1:4);
%     S35a(1:n-5)=S3a(6:n);
%     S35a(n-4:n)=S3a(1:5);
%     S36a(1:n-6)=S3a(7:n);
%     S36a(n-5:n)=S3a(1:6);
%     S37a(1:n-7)=S3a(8:n);
%     S37a(n-6:n)=S3a(1:7);
%     S38a(1:n-8)=S3a(9:n);
%     S38a(n-7:n)=S3a(1:8);
%     S39a(1:n-9)=S3a(10:n);
%     S39a(n-8:n)=S3a(1:9);
    
    S31b(1:n-1)=S3b(2:n);
    S31b(n)=S3b(1);
    
    S31c(1:n-1)=S3c(2:n);
    S31c(n)=S3c(1);
    
    S32c(3:n)=S3c(1:n-2);
    S32c(1:2)=S3c(n-1:n);
    
    S33c(1:n-2)=S3c(3:n);
    S33c(n-1:n)=S3c(1:2);

    S34c(2:n)=S3c(1:n-1);
    S34c(1)=S3c(n);
    
    S32b(3:n)=S3b(1:n-2);
    S32b(1:2)=S3b(n-1:n);
    
    S11cr=S1c(all);
    S12cr=S1c(bll);
    S13cr=S1c(cll);
    S14cr=S1c(dll);

    S11br=S1b(ell);
    S12br=S1b(fll);
    S13br=S1b(gll);
    S14br=S1b(hll);

    S11ar=S1a(ill);
    S12ar=S1a(jll);
    S13ar=S1a(kll);
    S14ar=S1a(lll);

    S81r=S8(mll);
    S82r=S8(nll);
    S83r=S8(oll);

    S51(1:n-1)=S5(2:n);
    S51(n)=S5(1);
    S52(1:n-2)=S5(3:n);
    S52(n-1:n)=S5(1:2);
    S53(1:n-3)=S5(4:n);
    S53(n-2:n)=S5(1:3);
    S54(1:n-4)=S5(5:n);
    S54(n-3:n)=S5(1:4);
    S55(1:n-5)=S5(6:n);
    S55(n-4:n)=S5(1:5);
    S56(1:n-6)=S5(7:n);
    S56(n-5:n)=S5(1:6);
    S57(1:n-7)=S5(8:n);
    S57(n-6:n)=S5(1:7);
    S58(1:n-8)=S5(9:n);
    S58(n-7:n)=S5(1:8);
    S59(1:n-9)=S5(10:n);
    S59(n-8:n)=S5(1:9);

    S61b(1:n-1)=S6b(2:n);
    S61b(n)=S6b(1);
    S62b(1:n-2)=S6b(3:n);
    S62b(n-1:n)=S6b(1:2);
    S63b(1:n-3)=S6b(4:n);
    S63b(n-2:n)=S6b(1:3);
    S64b(1:n-4)=S6b(5:n);
    S64b(n-3:n)=S6b(1:4);
    S65b(1:n-5)=S6b(6:n);
    S65b(n-4:n)=S6b(1:5);
    S66b(1:n-6)=S6b(7:n);
    S66b(n-5:n)=S6b(1:6);
    S67b(1:n-7)=S6b(8:n);
    S67b(n-6:n)=S6b(1:7);
    S68b(1:n-8)=S6b(9:n);
    S68b(n-7:n)=S6b(1:8);
    S69b(1:n-9)=S6b(10:n);
    S69b(n-8:n)=S6b(1:9);
    
    S61bn(1:n-1)=S6bn(2:n);
    S61bn(n)=S6bn(1);
    
    S91(1:n-1)=S9(2:n);
    S91(n)=S9(1);
    S92(1:n-2)=S9(3:n);
    S92(n-1:n)=S9(1:2);
    S93(1:n-3)=S9(4:n);
    S93(n-2:n)=S9(1:3);
    S94(1:n-4)=S9(5:n);
    S94(n-3:n)=S9(1:4);
    S95(1:n-5)=S9(6:n);
    S95(n-4:n)=S9(1:5);
    S96(1:n-6)=S9(7:n);
    S96(n-5:n)=S9(1:6);
    S97(1:n-7)=S9(8:n);
    S97(n-6:n)=S9(1:7);
    S98(1:n-8)=S9(9:n);
    S98(n-7:n)=S9(1:8);
    S99(1:n-9)=S9(10:n);
    S99(n-8:n)=S9(1:9);
    
    m1=th_minf(V1);
    m3=gpe_minf(V3);m4=gpe_minf(V4);
    n3=gpe_ninf(V3);n4=gpe_ninf(V4);
    h1=th_hinf(V1);
    h3=gpe_hinf(V3);h4=gpe_hinf(V4);
    p1=th_pinf(V1);
    a3=gpe_ainf(V3);a4=gpe_ainf(V4);
    s3=gpe_sinf(V3);s4=gpe_sinf(V4);
    r1=th_rinf(V1);
    r3=gpe_rinf(V3);r4=gpe_rinf(V4);

    tn3=gpe_taun(V3);tn4=gpe_taun(V4);
    th1=th_tauh(V1);
    th3=gpe_tauh(V3);th4=gpe_tauh(V4);
    tr1=th_taur(V1);tr3=30;tr4=30;
    
    n2=stn_ninf(V2);
    m2=stn_minf(V2);
    h2=stn_hinf(V2);
    a2=stn_ainf(V2);
    b2=stn_binf(V2);
    c2=stn_cinf(V2);
    d2=stn_d2inf(V2);
    d1=stn_d1inf(V2);
    p2=stn_pinf(V2);
    q2=stn_qinf(V2);
    r2=stn_rinf(V2);
 
    td2=130;
    tr2=2;
    tn2=stn_taun(V2);
    tm2=stn_taum(V2);
    th2=stn_tauh(V2);
    ta2=stn_taua(V2);
    tb2=stn_taub(V2);
    tc2=stn_tauc(V2);
    td1=stn_taud1(V2);
    tp2=stn_taup(V2);
    tq2=stn_tauq(V2);

    Ecasn=con*log(Cao./CAsn2);
   
   
    %thalamic cell currents
    Il1=gl(1)*(V1-El(1));
    Ina1=gna(1)*(m1.^3).*H1.*(V1-Ena(1));
    Ik1=gk(1)*((0.75*(1-H1)).^4).*(V1-Ek(1));
    It1=gt(1)*(p1.^2).*R1.*(V1-Et);
    Igith=ggith*(V1-Esyn(6)).*(S4); 
    Iappth=1.2;
 

    %STN cell currents
    Ina2=gna(2)*(M2.^3).*H2.*(V2-Ena(2));
    Ik2=gk(2)*(N2.^4).*(V2-Ek(2));
    Ia2=ga*(A2.^2).*(B2).*(V2-Ek(2));
    IL2=gL*(C2.^2).*(D1).*(D2).*(V2-Ecasn);
    It2=(gt(2)*(P2.^2).*(Q2).*(V2-Ecasn));
    Icak2=gcak*(R2.^2).*(V2-Ek(2));
    Il2=gl(2)*(V2-El(2));
    Igesn=(ggesn*((V2-Esyn(1)).*(S3a+S31a))); 
    Icorsnampa=gcorsna.*(V2-Esyn(2)).*(S6b+S61b);
    Icorsnnmda=gcorsnn.*(V2-Esyn(2)).*(S6bn+S61bn);

    %GPe cell currents
    Il3=gl(3)*(V3-El(3));
    Ik3=gk(3)*(N3.^4).*(V3-Ek(3));
    Ina3=gna(3)*(m3.^3).*H3.*(V3-Ena(3));
    It3=gt(3)*(a3.^3).*R3.*(V3-Eca(3));
    Ica3=gca(3)*(s3.^2).*(V3-Eca(3));
    Iahp3=gahp(3)*(V3-Ek(3)).*(CA3./(CA3+k1(3)));
    Isngeampa=(gsngea).*((V3-Esyn(2)).*(S2a+S21a)); 
    Isngenmda=(gsngen).*((V3-Esyn(2)).*(S2an+S21an)); % ILIJA: here's where you check what numbers/letters on synapse S mean
    Igege=(0.25*(pd*3+1))*(ggege).*(gsyn(3)*(V3-Esyn(3)).*(S31c+S32c)); 
    Istrgpe=gstrgpe*(V3-Esyn(6)).*(S5+S51+S52+S53+S54+S55+S56+S57+S58+S59);
    Iappgpe=3;

    %GPi cell currents
    Il4=gl(3)*(V4-El(3));
    Ik4=gk(3)*(N4.^4).*(V4-Ek(3));
    Ina4=gna(3)*(m4.^3).*H4.*(V4-Ena(3));
    It4=gt(3)*(a4.^3).*R4.*(V4-Eca(3));
    Ica4=gca(3)*(s4.^2).*(V4-Eca(3));
    Iahp4=gahp(3)*(V4-Ek(3)).*(CA4./(CA4+k1(3)));
    Isngi=(gsngi).*((V4-Esyn(4)).*(S2b+S21b));
    Igigi=ggigi*((V4-Esyn(5)).*(S31b+S32b)); 
    Istrgpi=gstrgpi*(V4-Esyn(6)).*(S9+S91+S92+S93+S94+S95+S96+S97+S98+S99);
    Iappgpi=3;

    %Striatum D2 cell currents
    Ina5=gna(4)*(m5.^3).*h5.*(V5-Ena(4));
    Ik5=gk(4)*(n5.^4).*(V5-Ek(4));
    Il5=gl(4)*(V5-El(4));
    Im5=(2.6-1.1*pd)*gm*p5.*(V5-Em);
    Igaba5=(ggaba/4)*(V5-Esyn(7)).*(S11cr+S12cr+S13cr+S14cr);
    Icorstr5=gcorindrstr*(V5-Esyn(2)).*(S6a);
    
    %Striatum D1 cell currents
    Ina6=gna(4)*(m6.^3).*h6.*(V6-Ena(4));
    Ik6=gk(4)*(n6.^4).*(V6-Ek(4));
    Il6=gl(4)*(V6-El(4));
    Im6=(2.6-1.1*pd)*gm*p6.*(V6-Em);
    Igaba6=(ggaba/3)*(V6-Esyn(7)).*(S81r+S82r+S83r);
    Icorstr6=gcordrstr.*(V6-Esyn(2)).*(S6a);
    
    %Excitatory Neuron Currents
    Iie=gie*(V7-Esyn(1)).*(S11br+S12br+S13br+S14br);
    Ithcor=gthcor*(V7-Esyn(2)).*(S7);

    
    %Inhibitory Neuron Currents
    Iei=gei*(V8-Esyn(2)).*(S11ar+S12ar+S13ar+S14ar);

    %Differential Equations for cells
    %thalamic
    vth(:,i)= V1+dt*(1/Cm*(-Il1-Ik1-Ina1-It1-Igith+Iappth));
    H1=H1+dt*((h1-H1)./th1);
    R1=R1+dt*((r1-R1)./tr1);

for j=1:n %ILIJA: loops for every neuron in the structure, to calculate S values

    OutsTH(j,i) = 0;
if (vth(j,i-1)<-10 && vth(j,i)>-10) % check for input spike
     t_list_th(j).times = [t_list_th(j).times; 1];
     OutsTH(j,i) = 1;
end   
   % Calculate synaptic current due to current and past input spikes
   S7(j) = sum(syn_func_th(t_list_th(j).times));

   % Update spike times
   if t_list_th(j).times
     t_list_th(j).times = t_list_th(j).times + 1;
     if (t_list_th(j).times(1) == t_a/dt)  % Reached max duration of syn conductance
       t_list_th(j).times = t_list_th(j).times((2:max(size(t_list_th(j).times))));
     end
   end
end
    
    %STN

    vsn(:,i)=V2+dt*(1/Cm*(-Ina2-Ik2-Ia2-IL2-It2-Icak2-Il2-Igesn-Icorsnampa-Icorsnnmda+Idbs(i))); %STN-DBS
    N2=N2+dt*((n2-N2)./tn2); 
    H2=H2+dt*((h2-H2)./th2);
    M2=M2+dt*((m2-M2)./tm2); 
    A2=A2+dt*((a2-A2)./ta2);
    B2=B2+dt*((b2-B2)./tb2); 
    C2=C2+dt*((c2-C2)./tc2);
    D2=D2+dt*((d2-D2)./td2); 
    D1=D1+dt*((d1-D1)./td1);
    P2=P2+dt*((p2-P2)./tp2); 
    Q2=Q2+dt*((q2-Q2)./tq2);
    R2=R2+dt*((r2-R2)./tr2); 
    
    CAsn2=CAsn2+dt*((-alp*(IL2+It2))-(Kca*CAsn2));
for j=1:n

%ILIJA CODE
InpsGPi(j,i) = 0; 
if (vsn(j,i-1)<-10 && vsn(j,i)>-10) % check for input spike
     t_list_stn(j).times = [t_list_stn(j).times; 1];
     InpsGPi(j,i) = 1;
end   
%ILIJA CODE END
   % Calculate synaptic current due to current and past input spikes
   S2a(j) = sum(syn_func_stn_gpea(t_list_stn(j).times));
   S2an(j) = sum(syn_func_stn_gpen(t_list_stn(j).times));

   S2b(j) = sum(syn_func_stn_gpi(t_list_stn(j).times));

   % Update spike times
   if t_list_stn(j).times
     t_list_stn(j).times = t_list_stn(j).times + 1;
     if (t_list_stn(j).times(1) == t_a/dt)  % Reached max duration of syn conductance
       t_list_stn(j).times = t_list_stn(j).times((2:max(size(t_list_stn(j).times))));
     end
   end
end
    
    %GPe
    vge(:,i)=V3+dt*(1/Cm*(-Il3-Ik3-Ina3-It3-Ica3-Iahp3-Isngeampa-Isngenmda-Igege-Istrgpe+Iappgpe));
    N3=N3+dt*(0.1*(n3-N3)./tn3);
    H3=H3+dt*(0.05*(h3-H3)./th3);
    R3=R3+dt*(1*(r3-R3)./tr3);
    CA3=CA3+dt*(1*10^-4*(-Ica3-It3-kca(3)*CA3));
for j=1:n

if (vge(j,i-1)<-10 && vge(j,i)>-10) % check for input spike
     t_list_gpe(j).times = [t_list_gpe(j).times; 1];
end   
   % Calculate synaptic current due to current and past input spikes
   S3a(j) = sum(syn_func_gpe_stn(t_list_gpe(j).times));
   S3b(j) = sum(syn_func_gpe_gpi(t_list_gpe(j).times));
   S3c(j) = sum(syn_func_gpe_gpe(t_list_gpe(j).times));


   % Update spike times
   if t_list_gpe(j).times
     t_list_gpe(j).times = t_list_gpe(j).times + 1;
     if (t_list_gpe(j).times(1) == t_a/dt)  % Reached max duration of syn conductance
       t_list_gpe(j).times = t_list_gpe(j).times((2:max(size(t_list_gpe(j).times))));
     end
   end
end
    
    %GPi
    vgi(:,i)=V4+dt*(1/Cm*(-Il4-Ik4-Ina4-It4-Ica4-Iahp4-Isngi-Igigi-Istrgpi+Iappgpi));
    N4=N4+dt*(0.1*(n4-N4)./tn4);
    H4=H4+dt*(0.05*(h4-H4)./th4);
    R4=R4+dt*(1*(r4-R4)./tr4);
    CA4=CA4+dt*(1*10^-4*(-Ica4-It4-kca(3)*CA4)); % ADDED VARIABLE
    %ILIJA CODE
    VoltValsGPi(1:10,i) = vgi(:,i);
    %ILIJA CODE END

for j=1:n
%ILIJA CODE
OutsGPi(j,i) = 0;
InpsTH(j,i) = 0;
if (vgi(j,i-1)<-10 && vgi(j,i)>-10) % check for input spike
     t_list_gpi(j).times = [t_list_gpi(j).times; 1];
     OutsGPi(j,i) = 1;
     InpsTH(j,i) = 1;
end       
%ILIJA CODE END
   % Calculate synaptic current due to current and past input spikes
   S4(j) = sum(syn_func_gpi_th(t_list_gpi(j).times));


   % Update spike times
   if t_list_gpi(j).times
     t_list_gpi(j).times = t_list_gpi(j).times + 1;
     if (t_list_gpi(j).times(1) == t_a/dt)  % Reached max duration of syn conductance
       t_list_gpi(j).times = t_list_gpi(j).times((2:max(size(t_list_gpi(j).times))));
     end
   end
end
    
    %Striatum D2
 vstr_indr(:,i)=V5+(dt/Cm)*(-Ina5-Ik5-Il5-Im5-Igaba5-Icorstr5);
 m5=m5+dt*(alpham(V5).*(1-m5)-betam(V5).*m5);
 h5=h5+dt*(alphah(V5).*(1-h5)-betah(V5).*h5);
 n5=n5+dt*(alphan(V5).*(1-n5)-betan(V5).*n5);
 p5=p5+dt*(alphap(V5).*(1-p5)-betap(V5).*p5);
 S1c=S1c+dt*((Ggaba(V5).*(1-S1c))-(S1c/tau_i));

for j=1:n

if (vstr_indr(j,i-1)<-10 && vstr_indr(j,i)>-10) % check for input spike
     t_list_str_indr(j).times = [t_list_str_indr(j).times; 1];
end   
   % Calculate synaptic current due to current and past input spikes
   S5(j) = sum(syn_func_str_indr(t_list_str_indr(j).times));

   % Update spike times
   if t_list_str_indr(j).times
     t_list_str_indr(j).times = t_list_str_indr(j).times + 1;
     if (t_list_str_indr(j).times(1) == t_a/dt)  % Reached max duration of syn conductance
       t_list_str_indr(j).times = t_list_str_indr(j).times((2:max(size(t_list_str_indr(j).times))));
     end
   end
end

% %Striatum D1 type
 vstr_dr(:,i)=V6+(dt/Cm)*(-Ina6-Ik6-Il6-Im6-Igaba6-Icorstr6);
 m6=m6+dt*(alpham(V6).*(1-m6)-betam(V6).*m6);
 h6=h6+dt*(alphah(V6).*(1-h6)-betah(V6).*h6);
 n6=n6+dt*(alphan(V6).*(1-n6)-betan(V6).*n6);
 p6=p6+dt*(alphap(V6).*(1-p6)-betap(V6).*p6);
 S8=S8+dt*((Ggaba(V6).*(1-S8))-(S8/tau_i));

 
 for j=1:n

if (vstr_dr(j,i-1)<-10 && vstr_dr(j,i)>-10) % check for input spike
     t_list_str_dr(j).times = [t_list_str_dr(j).times; 1];
end   
   % Calculate synaptic current due to current and past input spikes
   S9(j) = sum(syn_func_str_dr(t_list_str_dr(j).times));

   % Update spike times
   if t_list_str_dr(j).times
     t_list_str_dr(j).times = t_list_str_dr(j).times + 1;
     if (t_list_str_dr(j).times(1) == t_a/dt)  % Reached max duration of syn conductance
       t_list_str_dr(j).times = t_list_str_dr(j).times((2:max(size(t_list_str_dr(j).times))));
     end
   end
 end

%Excitatory Neuron
    ve(:,i)=V7+dt*((0.04*(V7.^2))+(5*V7)+140-ue(:,i-1)-Iie-Ithcor);
    ue(:,i)=ue(:,i-1)+dt*(ae*((be*V7)-ue(:,i-1)));
    
   for j=1:n
        if ve(j,i-1)>=30
        ve(j,i)=ce;
        ue(j,i)=ue(j,i-1)+de;
        
 t_list_cor(j).times = [t_list_cor(j).times; 1];
        end
   
   % Calculate synaptic current due to current and past input spikes
   S6a(j) = sum(syn_func_cor_d2(t_list_cor(j).times));
   S6b(j) = sum(syn_func_cor_stn_a(t_list_cor(j).times));
   S6bn(j) = sum(syn_func_cor_stn_n(t_list_cor(j).times));

   % Update spike times
   if t_list_cor(j).times
     t_list_cor(j).times = t_list_cor(j).times + 1;
     if (t_list_cor(j).times(1) == t_a/dt)  % Reached max duration of syn conductance
       t_list_cor(j).times = t_list_cor(j).times((2:max(size(t_list_cor(j).times))));
     end
   end
   
   end        
    
    ace=find(ve(:,i-1)<-10 & ve(:,i)>-10);
    uce=zeros(n,1); uce(ace)=gpeak/(tau*exp(-1))/dt;
    S1a=S1a+dt*Z1a; 
    z1adot=uce-2/tau*Z1a-1/(tau^2)*S1a;
    Z1a=Z1a+dt*z1adot;
    
    %Inhibitory InterNeuron
    vi(:,i)=V8+dt*((0.04*(V8.^2))+(5*V8)+140-ui(:,i-1)-Iei);
    ui(:,i)=ui(:,i-1)+dt*(ai*((bi*V8)-ui(:,i-1)));
    
   for j=1:n
        if vi(j,i-1)>=30
        vi(j,i)=ci;
        ui(j,i)=ui(j,i-1)+di;
        end
   end
        
    
    aci=find(vi(:,i-1)<-10 & vi(:,i)>-10);
    uci=zeros(n,1); uci(aci)=gpeak/(tau*exp(-1))/dt;
    S1b=S1b+dt*Z1b; 
    z1bdot=uci-2/tau*Z1b-1/(tau^2)*S1b;
    Z1b=Z1b+dt*z1bdot;


    end

    OutsVTH = vth;
    [TH_APs]  = find_spike_times(vth,t,n);
    [STN_APs] = find_spike_times(vsn,t,n);
    [GPe_APs] = find_spike_times(vge,t,n);
    [GPi_APs] = find_spike_times(vgi,t,n);
    [Striat_APs_indr]=find_spike_times(vstr_indr,t,n);
    [Striat_APs_dr]=find_spike_times(vstr_dr,t,n);
    [Cor_APs] = find_spike_times([ve;vi],t,2*n);
end
