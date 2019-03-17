function [d2inf] = stn_d2inf(V)
    d2inf=1./(1+exp((V-0.1)./0.02));
end
