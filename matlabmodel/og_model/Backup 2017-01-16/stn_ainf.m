function [ainf] = stn_ainf(V)
    ainf=1./(1+exp(-(V+45)./14.7));
end