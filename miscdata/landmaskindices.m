function ii=LandMaskIndices(indices)
% LANDMASKINDICES - return indices of standard (5minute) landmask

if nargin==0
    ii=find(LandMaskLogical);
else
    ii=find(LandMaskLogical);
    ii=ii(indices);
end
