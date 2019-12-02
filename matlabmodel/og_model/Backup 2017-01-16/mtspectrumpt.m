function [S,f,R,Serr]=mtspectrumpt(data,params,fscorr,t)

% Description:
%   Function that actually sets up and calculates the multitaper spectrum. Called in Make_Spectrum.
% inputs:
%   data: Raw data from the simulation. (Action potentials in ([s],[mV])
%   params(structure) { 
%       Fs: maximal frequency in spectrum
%       fpass: bandpass filter frequency
%       tapers: mutlitaper parameter in form [TimeBandwidthProduct NumberOfTapers]
%       trialave  Average of the trials }
%   fscorr:
%   t: time grid for prolates.
% outputs:
%   S: mean(conj(J).*J,2) with all singleton dimensions removed, where J is
%   actual multitaper spectrum for all channels
%   f: frequency grid values
%   R: Msp*Fs, where  Msp is mean value of points for which
%   (dtmp>=min(t)&dtmp<=max(t)) holds 
%   Serr: Output of spacerr (?)


if nargin < 1; error('Need data'); end;
if nargin < 2; params=[]; end;
[tapers,pad,Fs,fpass,err,trialave,params]=getparams(params);
clear params
data=change_row_to_column(data);
if nargout > 3 && err(1)==0; error('cannot compute error bars with err(1)=0; change params and run again'); end;
if nargin < 3 || isempty(fscorr); fscorr=0;end;
if nargin < 4 || isempty(t);
   [mintime,maxtime]=minmaxsptimes(data);
   dt=1/Fs; % sampling time
   t=mintime-dt:dt:maxtime+dt; % time grid for prolates
end;
N=length(t); % number of points in grid for dpss
nfft=max(2^(nextpow2(N)+pad),N); % number of points in fft of prolates
[f,findx]=getfgrid(Fs,nfft,fpass); % get frequency grid for evaluation
tapers=dpsschk(tapers,N,Fs); % check tapers
[J,Msp,Nsp]=mtfftpt(data,tapers,nfft,t,f,findx); % mt fft for point process times
S=squeeze(mean(conj(J).*J,2));
if trialave; S=squeeze(mean(S,2));Msp=mean(Msp);end;
R=Msp*Fs;
if nargout==4;
   if fscorr==1;
      Serr=specerr(S,J,err,trialave,Nsp);
   else
      Serr=specerr(S,J,err,trialave);
   end;
end;
end