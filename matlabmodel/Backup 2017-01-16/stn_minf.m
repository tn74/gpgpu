function [minf] = stn_minf(V)
    minf=1./(1+exp(-(V+40)./8));
end