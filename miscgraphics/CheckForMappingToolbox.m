function  CanMap=checkformappingtoolbox;
% CHECKFORMAPPINGTOOLBOX - check to see if mapping toolbox is available
%
%  Syntax
%
%    checkformappingtoolbox
%
%   See Also  mappingoff mappingon

global DONOTUSEMAPPINGTOOLBOX

if ~isempty(DONOTUSEMAPPINGTOOLBOX)
    if DONOTUSEMAPPINGTOOLBOX==1
        disp(['Preferences set to not use mapping toolbox'])
        disp(['MappingOn to change'])
        CanMap=0;
        return
    end
end


result = license('checkout','map_toolbox');
try
    %  if isequal(S.feature,'map_toolbox')
    %    CanMap=1;
    %  else
    %    CanMap=0;
    %  end
    
    if result==0
        disp(['Couldn''t check out mapping toolbox'])
    end
    CanMap=result;
    
catch
    warning(['problem in ' mfilename ])
    CanMap=0;
end

