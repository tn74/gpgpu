function out = CleanUpTimers(in,CondTime)
% Description:
%	Cleans up unused timers
% Inputs:
%	Cell Array of timer values
% Outputs:
%	Cell Array of cleaned timer values

    out = cellfun(@(x) x(x<CondTime), in,'UniformOutput',false);

end