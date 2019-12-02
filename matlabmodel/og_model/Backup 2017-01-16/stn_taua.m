function [tau] = stn_taua(V)
    tau=1+1./(1+exp(-(V+40)./-0.5));
end