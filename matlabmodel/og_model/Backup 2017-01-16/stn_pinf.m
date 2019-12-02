function [pinf] = stn_pinf(V)
    pinf=1./(1+exp(-(V+56)./6.7));
end