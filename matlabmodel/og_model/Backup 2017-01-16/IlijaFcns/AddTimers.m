function out = AddTimers(in,Triggers)
% Description:
%	Adds timers to triggering inputs
% Inputs:
%	in: Cell Array of timer values
%   Triggers: Array indicating which neurons are triggering
% Outputs:
%	out: Cell Array with added timers

    changed = cellfun(@(x) [x 0], in(Triggers>0.5),'UniformOutput',false);
    in(Triggers>0.5) = changed;
    out = in;

end