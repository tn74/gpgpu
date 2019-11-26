function [J,Msp,Nsp]=mtfftpt(data,tapers,nfft,t,f,findx)

% Description:
%   Low level function that actually calculates the multitaper spectrum.
% inputs:
%   data: Raw data from the simulation. (Action potentials in ([s],[mV])
%   tapers: mutlitaper parameter in form [TimeBandwidthProduct NumberOfTapers]
%   nfft: number of frequency grid values over spectrum. Resolution is Fs/nfft
%   t: time grid values
%   f: frequency grid values
%   findx: indicies of the bandpassed frequencies (f) in the whole
%   frequency axis of the "data"
% outputs:
%   J: Actual multitaper spectrum for all channels
%   Msp: Mean value of points fo which(dtmp>=min(t)&dtmp<=max(t)) holds
%   Nsp: Number of points for which (dtmp>=min(t)&dtmp<=max(t)) holds

if nargin < 6; error('Need all input arguments'); end;
if isstruct(data); C=length(data); else C=1; end% number of channels
K=size(tapers,2); % number of tapers
nfreq=length(f); % number of frequencies
if nfreq~=length(findx); error('frequency information (last two arguments) inconsistent'); end;
H=fft(tapers,nfft,1);  % fft of tapers
H=H(findx,:); % restrict fft of tapers to required frequencies
w=2*pi*f; % angular frequencies at which ft is to be evaluated
Nsp=zeros(1,C); Msp=zeros(1,C);
for ch=1:C;
  if isstruct(data);
     fnames=fieldnames(data);
     eval(['dtmp=data(ch).' fnames{1} ';'])
     indx=find(dtmp>=min(t)&dtmp<=max(t));
     if ~isempty(indx); dtmp=dtmp(indx);
     end;
  else
     dtmp=data;
     indx=find(dtmp>=min(t)&dtmp<=max(t));
     if ~isempty(indx); dtmp=dtmp(indx);
     end;
  end;
  Nsp(ch)=length(dtmp);
  Msp(ch)=Nsp(ch)/length(t);
  if Msp(ch)~=0;
      data_proj=interp1(t',tapers,dtmp);
      exponential=exp(-1i*w'*(dtmp-t(1))');
      J(:,:,ch)=exponential*data_proj-H*Msp(ch);
  else
      J(1:nfreq,1:K,ch)=0;
  end;
end;
end