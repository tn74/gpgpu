function out = TestFcn(in)

persistent a b;

if isempty(a)
    a=1;
    b=2;
end

out = in+a+b;
a = a+1;
b = b+1;
end