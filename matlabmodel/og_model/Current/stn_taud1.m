function [tau] = stn_taud1(V)
    tau=400+500./(exp(-(V+40)./-15)+exp(-(V+20)./20));
end