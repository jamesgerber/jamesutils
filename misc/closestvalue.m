function [Val,ii]=ClosestValue(y,y0)
% ClosestValue - determine closest value, and index of closest value
%
%  Syntax
%     [value,index]=ClosestValue(Values,Value)
%
%  EXAMPLE
%   A=rand(5)
%   [value,index]=ClosestValue(A,.5)

if nargin<2
    help(mfilename)
    return
end

for i=1:numel(y0)
    [~,ii(i)]=min(abs(y(:)-y0(i)));
    Val(i)=y(ii(i));
end