function [tau] = stn_taub(V)
    tau=200./(exp(-(V+60)./-30)+exp(-(V+40)./10));
end