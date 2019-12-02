function [qinf] = stn_qinf(V)
    qinf=1./(1+exp((V+85)./5.8));
end