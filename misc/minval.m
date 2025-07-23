function m=minval(A)
% MINVAL - return minimum element of A of any dimension
%
% SYNTAX
% m=minval(A) returns the minimum element of A
%
% EXAMPLE
% m=minval(rand(5,5,5,5,5,5))
%

m=A;
for i=1:length(size(A))
    m=min(m);
end