function [tau] = stn_tauc(V)
    tau=45+10./(exp(-(V+27)./-20)+exp(-(V+50)./15));
end