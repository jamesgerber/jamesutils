function [ii,value]=closest(vec,val)
% closest - return closest linear index
%
%  Syntax
%       ii=closest(matrix,value)
%       [ii,closevalue]=closest(matrix,value)
%
%  EXAMPLE
%       A=rand(5)
%       ii=closest(A,.5)
%
%  See also  ClosestValue

if length(val)==1
    [value,ii]=ClosestValue(vec,val);
else
    [value,ii]=ClosestValue(val,vec);
end