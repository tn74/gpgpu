function [d1inf] = stn_d1inf(V)
    d1inf=1./(1+exp((V+60)./7.5));
end
