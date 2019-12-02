clear all;close all;clc;

%addpath(genpath('D:\DukeRepo\DBS\Matlab'));
addpath(genpath('D:\SVN repository\DBS\Matlab'));

pd = 0; %parkinson disease 1/0
tmax = 10000; %ms
dt = 0.01; %ms
t = 0:dt:tmax;
n = 10; %number of neurons per region
saveData = zeros(n,length(t));

%% DBS Parameters
PW = 0.3;           % ms [DBS pulse width]
amplitude = 300;    % nA/cm2 [DBS current amplitude]
freqs=0:5:200;      % DBS frequency in Hz
pick=1;%23
pattern = freqs(pick);
if pick==1    
  Idbs=zeros(1,length(t));   
else
  Idbs=creatdbs(pattern,tmax,dt,PW,amplitude);  
end

%% initialize input output relations
InpSTNtoGPE_ampa1=zeros(n,1);
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


%% Start simulation iterating
for i=1:length(t)
    ManipulateInpOutReduced;
    %TH
    [OutTH,~] = ThalamusReduced(InpGPItoTH,1,dt);
    %STN
    [OutSTN,~] = SubThalamicNucleusReduced(InpGPEtoSTN1,InpGPEtoSTN2,0,1,dt); %DBS zero for now
    %GPE
    [OutGPE,~] = GlobusPallidusExternaReduced(InpSTNtoGPE_ampa1,InpSTNtoGPE_ampa2,InpSTNtoGPE_nmda1,InpSTNtoGPE_nmda2,InpGPEtoGPE1,InpGPEtoGPE2,1,pd,dt);
    %GPI
    [OutGPI,debug] = GlobusPallidusInternaReduced(InpSTNtoGPI1,InpSTNtoGPI2,InpGPEtoGPI2,InpGPEtoGPI3,1,dt);
    %relate outputs to future inputs
    InpGPItoTH = OutGPI;
    InpSTNtoGPE_ampa1 = OutSTN;
    InpSTNtoGPE_nmda1 = OutSTN;
    InpSTNtoGPI1 = OutSTN;
    InpGPEtoSTN1 = OutGPE;
    InpGPEtoGPI1 = OutGPE;
    InpGPEtoGPE = OutGPE;
    
    %record simulation data
    saveData(:,i) = OutGPI;
end