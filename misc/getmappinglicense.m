function GetMappingLicense(N)
% GetMappingLicense - will try every N seconds (default 10) to get a
% mappingtoolboxlicense
%
%  Syntax
%
% GetMappingLicense
%
%  GetMappingLicense(5)
%
%
%  See Also:
%
if nargin==0
    N=10;
end

done=0;

while ~done;

try   
    nm2sm(3)
   done=1;
   disp(['Have a mapping toolbox'])
catch
    disp(['Can''t get mapping toolbox.  Trying again ...'])
    pause(10)
end

end
