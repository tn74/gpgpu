function [f,findx]=getfgrid(Fs,nfft,fpass)

% Description:
%   Creates frequency axis for the spectrum.
% inputs:
%   Fs: Fs: maximal frequency in spectrum
%   nfft: number of frequency grid values over spectrum. Resolution is Fs/nfft
%   fpass: bandpass filter frequencies
% outputs:
%   f: frequency axis for the given band
%   findx: indicies of the given band in the whole frequency axis

if nargin < 3; error('Need all arguments'); end;
df=Fs/nfft;
f=0:df:Fs; % all possible frequencies
f=f(1:nfft);
if length(fpass)~=1;
   findx=find(f>=fpass(1) & f<=fpass(end));
else
   [fmin,findx]=min(abs(f-fpass));
   clear fmin
end;
f=f(findx);
end