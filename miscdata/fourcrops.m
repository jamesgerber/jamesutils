function cl=fourcrops(varargin)
% FOURCROPS - get the names of the four main crops
%
% SYNTAX
% c=tencrops - set c to a cell array of the sixteen main crops

cl={'maize',...
'rice',...
'soybean',...
'wheat'};

if nargin==1

    x=varargin{1};
    if numel(x)>1
        
        cl=cl(x);
    else
        cl=cl{varargin{1}};
    end
end

