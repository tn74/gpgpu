function data=change_row_to_column(data)

% Description:
%   If input is a row vector, converts to column vector. If it is one
%   element structure, does the same for that element in structure.
% Inputs:
%   data: Matrix or structure of input data
% Outputs:
%   data: Column vector, or input data

dtmp=[];
if isstruct(data);
   C=length(data);
   if C==1;
      fnames=fieldnames(data);
      eval(['dtmp=data.' fnames{1} ';'])
      data=dtmp(:);
   end
else
  [N,C]=size(data);
  if N==1 || C==1;
    data=data(:);
  end;
end;
end