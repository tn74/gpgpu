function [hinf] = stn_hinf(V)
    hinf=1./(1+exp((V+45.5)./6.4));
end
