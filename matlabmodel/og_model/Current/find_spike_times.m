function [data] = find_spike_times(v,t,nn)


    data(1:nn) = struct('times',[]);
    t = t./1000;    % unit: second
    for k = 1:nn
        data(k).times = t(diff(v(k,:)>-20)==1)';
    end

end
