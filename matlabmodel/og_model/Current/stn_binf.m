function [binf] = stn_binf(V)
    binf=1./(1+exp((V+90)./7.5));
end