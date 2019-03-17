function [tau] = stn_taun(V)
    tau=11./(exp(-(V+40)./-40)+exp(-(V+40)./50));
end