function [tau] = stn_taum(V)
    tau=0.2+3./(1+exp(-(V+53)./-0.7));
end