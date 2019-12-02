function [tau] = stn_tauq(V)
    tau=400./(exp(-(V+50)./-15)+exp(-(V+50)./16));
end
