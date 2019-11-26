function [area S f] = make_Spectrum(raw,params)

% Description: 
%   Creates a multitaper spectrum out of raw "recorded" (simulated) data.
% inputs:
%   raw: Raw data from the simulation. (Action potentials in ([s],[mV])
%   params(structure) { 
%       Fs: maximal frequency in spectrum
%       fpass: bandpass filter frequency (?)
%       tapers: mutlitaper parameter in form [TimeBandwidthProduct NumberOfTapers] (?)
%       trialave  Average of the trials }
% outputs:
%   area: Area under the spectrum in beta band - spectrum power
%   S: Spectral power (whole spectrum)
%   f: Spectral frequencies (whole spectrum)

% Compute Multitaper Spectrum
[S,f] = mtspectrumpt(raw,params);
beta = S(f>7 & f<35); %beta frequency band, spectrum
betaf = f(f>7 & f<35); %beta frequency band, frequencies
area = trapz(betaf,beta); %calculates integral, trapezoidal method

end