pd = 1;
tmax = 100; %ms
dt = 0.01; %ms
n = 10;
pick = 23; %frequency of stimulation / 5

% DBS Parameters

PW = 0.3;           % ms [DBS pulse width]
amplitude = 300;    % nA/cm2 [DBS current amplitude]
freqs=0:5:200;      % DBS frequency in Hz
pattern = freqs(pick);

if pick==1
    
  Idbs=zeros(1,length(t)); 
  
else

  Idbs=creatdbs(pattern,tmax,dt,PW,amplitude);
  
end

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
    v1=-62+randn(n,1)*5;
    v2=-62+randn(n,1)*5;    %STN
    v3=-62+randn(n,1)*5;    %GPe
    v4=-62+randn(n,1)*5;    %GPi
    v5=-63.8+randn(n,1)*5;  %STRind
    v6=-63.8+randn(n,1)*5;  %STRdr

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






%% Setting initial matrices
%vth=zeros(n,length(t)); %thalamic membrane voltage
vsn=zeros(n,length(t)); %STN membrane voltage
vge=zeros(n,length(t)); %GPe membrane voltage
vgi=zeros(n,length(t)); %GPi membrane voltage
vstr_indr=zeros(n,length(t)); %Indirect Striatum membrane voltage
vstr_dr=zeros(n,length(t)); %Direct Striatum membrane voltage
ve=zeros(n,length(t)); %Excitatory Cortex membrane voltage
vi=zeros(n,length(t)); %Inhibitory Cortex membrane voltage
ue=zeros(n,length(t)); %Cortex is governed by different model
ui=zeros(n,length(t));  %Check Appendix_A



%% initial conditions
%vth(:,1)=v1;
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
H3=gpe_hinf(vge(:,1));H4=gpe_hinf(vgi(:,1));
R3=gpe_rinf(vge(:,1));R4=gpe_rinf(vgi(:,1));
CA2=0.1; 
CA3=CA2;CA4=CA2; 

m5=alpham(vstr_indr(:,1))./(alpham(vstr_indr(:,1))+betam(vstr_indr(:,1)));
h5=alphah(vstr_indr(:,1))./(alphah(vstr_indr(:,1))+betah(vstr_indr(:,1)));
n5=alphan(vstr_indr(:,1))./(alphan(vstr_indr(:,1))+betan(vstr_indr(:,1)));
p5=alphap(vstr_indr(:,1))./(alphap(vstr_indr(:,1))+betap(vstr_indr(:,1)));
m6=alpham(vstr_dr(:,1))./(alpham(vstr_dr(:,1))+betam(vstr_dr(:,1)));
h6=alphah(vstr_dr(:,1))./(alphah(vstr_dr(:,1))+betah(vstr_dr(:,1)));
n6=alphan(vstr_dr(:,1))./(alphan(vstr_dr(:,1))+betan(vstr_dr(:,1)));
p6=alphap(vstr_dr(:,1))./(alphap(vstr_dr(:,1))+betap(vstr_dr(:,1))); 

%% Synapse parameters
gsyn = [1 0.3 1 0.3 1 .08]; Esyn = [-85 0 -85 0 -85 -85 -80];
tau=5; tau_i=13; gpeak=0.43; gpeak1=0.3; 

InpSTNtoGPE_ampa1=zeros(n,1); %ctrl+f ILIJA
InpSTNtoGPE_ampa2=zeros(n,1); 
InpSTNtoGPI1=zeros(n,1); 
InpSTNtoGPI2=zeros(n,1); 
InpSTNtoGPE_nmda1=zeros(n,1); 
InpSTNtoGPE_nmda2=zeros(n,1); 
InpGPEtoSTN1=zeros(n,1); 
InpGPEtoSTN2=zeros(n,1); 
InpGPEtoGPI1=zeros(n,1);
InpGPEtoGPI2=zeros(n,1);
InpGPEtoGPE=zeros(n,1);
InpGPEtoGPE1=zeros(n,1); 
InpGPEtoGPE2=zeros(n,1); 
InpGPItoTH=zeros(n,1); 
InpSTRtoGPE1=zeros(n,1);
InpSTRtoGPE2=zeros(n,1);
InpSTRtoGPE3=zeros(n,1);
InpSTRtoGPE4=zeros(n,1);
InpSTRtoGPE5=zeros(n,1);
InpSTRtoGPE6=zeros(n,1);
InpSTRtoGPE7=zeros(n,1);
InpSTRtoGPE8=zeros(n,1);
InpSTRtoGPE9=zeros(n,1);
InpSTRtoGPE10=zeros(n,1);
InpSTRtoGPI1=zeros(n,1); 
InpRCTXtoSTR=zeros(n,1); %BOTH OF THEM (id and d)!
InpRCTXtoSTN_ampa1=zeros(n,1);
InpRCTXtoSTN_nmda1=zeros(n,1);
InpRCTXtoSTN_nmda2=zeros(n,1);
InpRCTXtoSTN_ampa2=zeros(n,1);
InpSTRtoGPI2=zeros(n,1);
InpSTRtoGPI3=zeros(n,1);
InpSTRtoGPI4=zeros(n,1);
InpSTRtoGPI5=zeros(n,1);
InpSTRtoGPI6=zeros(n,1);
InpSTRtoGPI7=zeros(n,1);
InpSTRtoGPI8=zeros(n,1);
InpSTRtoGPI9=zeros(n,1);
InpSTRtoGPI10=zeros(n,1);
InpTHtoRCTX=zeros(n,1);
InpDSTRtoDSTR=zeros(n,1);
OutICTX=zeros(n,1); 
OutRCTX=zeros(n,1);
InpRCTXtoRCTX=zeros(n,1);
InpICTXtoICTX=zeros(n,1);

%TODO delete this? unneeded with new functions
t_max_con = 1000; % Max duration of syn conductance <---- actually used!
t_vec = 0:dt:t_max_con;
const = gpeak/(tau*exp(-1));
const1 = gpeak1/(tau*exp(-1)); 
%Up to here
const2 = gpeak1/(tau*exp(-1)); 

%% set up randomized connections
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