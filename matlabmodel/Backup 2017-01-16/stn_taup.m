function [tau] = stn_taup(V)
    tau=5+0.33./(exp(-(V+27)./-10)+exp(-(V+102)./15));
end