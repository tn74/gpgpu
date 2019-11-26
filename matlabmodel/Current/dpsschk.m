function [tapers,eigs]=dpsschk(tapers,N,Fs)

% Description:
%   Checks if the tapers are set up properly.
% inputs:
%   tapers: Actual tapers used for the analysis
%   N: Number of points in time grid
%   Fs: maximal frequency in spectrum
% outputs:
%   tapers: First 2*N discrete prolate spheroidal sequences of length
%   "tapers"
%   eigs: Corresponding concentrations of tapers

if nargin < 3; error('Need all arguments'); end
sz=size(tapers);
if sz(1)==1 && sz(2)==2;
    [tapers,eigs]=dpss(N,tapers(1),tapers(2)); %Discrete prolate spheroidal sequences - used in multitaper spectral analysis
    tapers = tapers*sqrt(Fs);
elseif N~=sz(1);
    error('seems to be an error in your dpss calculation; the number of time points is different from the length of the tapers');
end;
end