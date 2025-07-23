function x=fma(varargin)
% fma - alias for getfivemingridcellareas
%

if nargin==0;
    x=getfivemingridcellareas;
else
    x=getfivemingridcellareas(varargin{1:end});
end