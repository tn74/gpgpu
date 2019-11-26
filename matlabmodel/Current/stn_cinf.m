function [cinf] = stn_cinf(V)
    cinf=1./(1+exp(-(V+30.6)./5));
end
