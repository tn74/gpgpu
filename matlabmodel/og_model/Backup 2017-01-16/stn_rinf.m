function [rinf] = stn_rinf(V)
    rinf=1./(1+exp(-(V-0.17)./0.08));
end