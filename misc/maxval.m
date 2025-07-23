function m=maxval(A)
% MAXVAL - return maximum element of A of any dimension
%
% SYNTAX
% m=maxval(A) returns the maximum element of A
%
% EXAMPLE
% m=maxval(rand(5,5,5,5,5,5))
%

m=A;
for i=1:length(size(A))
    m=max(m);
end