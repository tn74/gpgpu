clear all;close all;clc;

%addpath(genpath('D:\DukeRepo\DBS\Matlab'));
%addpath(genpath('C:\Users\Ilija\Dropbox\Deep Brain Stimulation Project\Model\Current')); %change this in relation 
addpath(genpath('..'));

LoadConfig = 0; ConfigFileName = 'Config recorded at 17_08 on 02_13_2017.mat'; %Use this command to load predefined brain configuration 0-generate, 1-load
SaveConfig = 0; %set to 1 to save the brain configuration

if LoadConfig
    load(ConfigFileName);
else
    pd = 1; %parkinson disease 1/0
    tmax = 100; %ms
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
    InitializeInpOutRelations; 
    if SaveConfig
        save(['Config recorded at ' datestr(datetime('now'),'HH_MM') ' on ' datestr(datetime('now'),'mm_dd_yyyy') '.mat']);
    end
end

%% Start simulation iterating
for i=1:length(t)
   % i
    ManipulateInpOut;
    %TH
    [OutTH,~] = Thalamus(InpGPItoTH,1,dt);
    %STN
    [OutSTN,~] = SubThalamicNucleus(InpGPEtoSTN1,InpGPEtoSTN2,InpRCTXtoSTN_ampa1,InpRCTXtoSTN_ampa2,InpRCTXtoSTN_nmda1,InpRCTXtoSTN_nmda2,0,1,dt); %DBS zero for now
    %GPE
    [OutGPE,~] = GlobusPallidusExterna(InpSTNtoGPE_ampa1,InpSTNtoGPE_ampa2,InpSTNtoGPE_nmda1,InpSTNtoGPE_nmda2,InpGPEtoGPE1,InpGPEtoGPE2,InpSTRtoGPE1,InpSTRtoGPE2,InpSTRtoGPE3,InpSTRtoGPE4,InpSTRtoGPE5,InpSTRtoGPE6,InpSTRtoGPE7,InpSTRtoGPE8,InpSTRtoGPE9,InpSTRtoGPE10,1,pd,dt);
    %GPI
    [OutGPI,debug] = GlobusPallidusInterna(InpSTNtoGPI1,InpSTNtoGPI2,InpGPEtoGPI2,InpGPEtoGPI3,InpSTRtoGPI1,InpSTRtoGPI2,InpSTRtoGPI3,InpSTRtoGPI4,InpSTRtoGPI5,InpSTRtoGPI6,InpSTRtoGPI7,InpSTRtoGPI8,InpSTRtoGPI9,InpSTRtoGPI10,1,dt);
    %idSTR
    [OutIDSTR,~] = IndirectStriatum(InpRCTXtoIDSTR,1,pd,dt); 
    %dSTR
    [OutDSTR,~] = DirectStriatum(InpRCTXtoDSTR,1,pd,dt);
    %RCTX
    [OutRCTXbool,OutRCTXforICTX,~] = ExcitatoryCTX(InpTHtoRCTX,InpICTXtoRCTX1,InpICTXtoRCTX2,InpICTXtoRCTX3,InpICTXtoRCTX4,1,dt);
    %ICTX
    [OutICTXforRCTX,~] = InhibitoryCTX(InpRCTXtoICTX1,InpRCTXtoICTX2,InpRCTXtoICTX3,InpRCTXtoICTX4,1,dt);
    %relate outputs to future inputs
    InpTHtoRCTX = OutTH;
    InpGPItoTH = OutGPI;
    InpSTNtoGPE_ampa1 = OutSTN;
    InpSTNtoGPE_nmda1 = OutSTN;
    InpSTNtoGPI1 = OutSTN;
    InpGPEtoSTN1 = OutGPE;
    InpGPEtoGPI1 = OutGPE;
    InpGPEtoGPE = OutGPE;
    OutICTX = OutICTXforRCTX;
    OutRCTX = OutRCTXforICTX;
    InpSTRtoGPE1 = OutIDSTR;
    InpRCTXtoSTN_ampa1 = OutRCTXbool;
    InpRCTXtoSTN_nmda1 = OutRCTXbool;
    InpSTRtoGPI1 = OutDSTR;    
    InpRCTXtoIDSTR = OutRCTXbool;
    InpRCTXtoDSTR = OutRCTXbool;
    
    %record simulation data
    saveData(:,i) = OutGPI;
end