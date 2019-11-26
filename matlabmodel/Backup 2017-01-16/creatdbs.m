function Idbs=creatdbs(pattern,tmax,dt,PW,amplitude)

% inputs:
%   pattern: DBS frequency
%   tmax: simulation time
%   dt: simulation time resolution
%   PW: duration of the pulse in ms
%   amplitude: amplitude of the pulse in mV
% outputs:
%   Idbs: output of the deep brain stimulator

t=0:dt:tmax; Idbs=zeros(1,length(t)); 
iD=amplitude;
pulse=iD*ones(1,PW/dt); %creates "one pulse" for one period



i=1;
while i<length(t)
      
    Idbs(i:i+PW/dt-1)=pulse; %insert pulse at start of the period
    instfreq=pattern; %set instfreq to frequency of DBS
    isi=1000/instfreq; %isi is period of DBS in ms
    i=i+round(isi*1/dt); %"go to" next period and continue adding the pulse
 end

end

