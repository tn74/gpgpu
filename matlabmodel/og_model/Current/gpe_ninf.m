function [ninf] = gpe_ninf(V)
% Description:
%	Calculates steady state variable (state of the ionic channel).  
% Inputs:
%	V: voltage of the neuron
% Outputs:
%	ninf: steady state value from [0,1] interval

    ninf=1./(1+exp(-(V+50)./14));
end
