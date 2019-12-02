function [ninf] = stn_ninf(V)
    ninf=1./(1+exp(-(V+41)./14));
end