function val=percentile(A,p)
% percentile - give a value at a certain percentile
%
% SYNTAX
% val=percentile(A,p) returns the value of the p percentile of A or the p*100
% percentile of A if p is <= 1
%
% EXAMPLE
% val=percentile(1:100,.33333);
%

if p>1
    p=p/100;
end
L=sort(A(:));
val=L(round(length(L)*p));