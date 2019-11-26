function [b] = bh(V)
    b=4./(1+exp(-(V+23)./5)); % part of th_tauh fxn
end
