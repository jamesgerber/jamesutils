function Nbadpergood=justhotspot(varargin);%area,goodthingperha,badthingperha,percentage);
%  justhotspot - helper function that calls hotspot, returns a scalar
%  
%   this is useful to allow for in-line function calls
%
%  example
%
%   disp([num2str( ...
%   justhotspot(area,goodthingperha,badthingperha,percentage))]);
%

%use varargin syntax so i can pass a flag through to hotspot

[HotSpot,Tradeoff]=hotspot(varargin{:});%area,goodthingperha,badthingperha,percentage);
Nbadpergood=HotSpot.RG;

