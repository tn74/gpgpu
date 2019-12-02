function [tau] = stn_tauh(V)
    tau=24.5./(exp(-(V+50)./-15)+exp(-(V+50)./16));
end