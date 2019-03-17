function [tapers,pad,Fs,fpass,err,trialave,params]=getparams(params)

% Description:
%   gets/sets the parameters for the tapper spectrum analyzer. Sets them to default, if not already set.
% inputs:
%   params(structure) { 
%       Fs: maximal frequency in spectrum
%       fpass: bandpass filter frequency
%       tapers: mutlitaper parameter in form [TimeBandwidthProduct NumberOfTapers] (?)
%       trialave  Average of the trials }
% outputs:
%   tapers: mutlitaper parameter in form [TimeBandwidthProduct NumberOfTapers]
%   pad: 
%   Fs: maximal frequency in spectrum
%   fpass: Frequency band for the bandpass prefiltering
%   err: Spectrum estimation error
%   trialave: Average of the trials
%   params: Structure of all of the values above

if ~isfield(params,'tapers') || isempty(params.tapers);  %If the tapers don't exist
     display('tapers unspecified, defaulting to params.tapers=[3 5]');
     params.tapers=[3 5];
end;
if ~isempty(params) && length(params.tapers)==3 
    % Compute timebandwidth product
    TW = params.tapers(2)*params.tapers(1);
    % Compute number of tapers
    K  = floor(2*TW - params.tapers(3));
    params.tapers = [TW  K];
end

if ~isfield(params,'pad') || isempty(params.pad);
    params.pad=0;
end;
if ~isfield(params,'Fs') || isempty(params.Fs);
    params.Fs=1;
end;
if ~isfield(params,'fpass') || isempty(params.fpass);
    params.fpass=[0 params.Fs/2];
end;
if ~isfield(params,'err') || isempty(params.err);
    params.err=0;
end;
if ~isfield(params,'trialave') || isempty(params.trialave);
    params.trialave=0;
end;

tapers=params.tapers;
pad=params.pad;
Fs=params.Fs;
fpass=params.fpass;
err=params.err;
trialave=params.trialave;
end