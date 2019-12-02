function [] = stndbs_tuning_curve(IT,pd,pick)

% Description:
%   "Main function", start of the code.
% inputs:
%   IT - iteration number
%   pd - 0(normal/healthy condition), 1(Parkinson's disease(PD) condition)
%   pick - DBS frequency calculated as pick*5 Hz
% outputs:
%   null

%rng shuffle

n = 10;             % number of neurons in each nucleus
tmax = 100;       % ms should be 10k
dt = 0.01;          % ms
t=0:dt:tmax;


% DBS Parameters

PW = 0.3;           % ms [DBS pulse width]
amplitude = 300;    % nA/cm2 [DBS current amplitude]
freqs=0:5:200;      % DBS frequency in Hz
pattern = freqs(pick);

% Create DBS Current

if pick==1
    
  Idbs=zeros(1,length(t)); 
  
else

  Idbs=creatdbs(pattern,tmax,dt,PW,amplitude);
  
end

% Run CTX-BG-TH Network Model
[TH_APs STN_APs GPe_APs GPi_APs Striat_APs_indr Striat_APs_dr Cor_APs vth VoltValsGPi InpsGPi OutsGPi InpsTH OutsTH OutsVTH] = CTX_BG_TH_network(pd,tmax,dt,n,Idbs);

% % Calculate GPi pathological low-frequency oscillatory power
% dt1=0.01*10^-3;
% params.Fs = 1/dt1; %Hz
% params.fpass = [1 100];
% params.tapers = [3 5];
% params.trialave = 1;
% 
% [gpi_alpha_beta_area gpi_S gpi_f]=make_Spectrum(GPi_APs,params); %GPi_APs = GPi action potentials
% 
% % gpi_alpha_beta_area - GPi spectral power integrated in 7-35Hz band
% % gpi_S - GPi spectral power
% % gpi_f - GPi spectral frequencies
%  
% 
%  name = [num2str(IT) 'stndbs_freq' num2str(pattern) '.mat'];
%  eval(['save ' name])



%quit

end

