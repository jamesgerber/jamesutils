function ii=CropMaskIndices(varargin);
% CROPMASKINDICES - return indices of standard (5minute) data mask
ii=find(CropMaskLogical);

if nargin==1
    if ~ischar(varargin{1})
        %haven't passed in a string.  probably a number.  index into ii
        
        ii=ii(varargin{1});
    end
end
