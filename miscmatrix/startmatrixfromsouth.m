function [long,latnew,matrixnew]=startmatrixfromsouth(long,lat,matrix);
% startmatrixfromsouth - put matrix into start-from-south format
%
%  [long,latnew,matrixnew]=startmatrixfromsouth(long,lat,matrix);
%
%   identity operator if already in this format

if nargin==0
    help(mfilename)
    return
end

if numel(long) ~=size(matrix,1)
    warning('matrix not in row-longitude format')
end

if lat(1) < lat(end)
    % already in this format
    latnew=lat;
    matrixnew=matrix;
else
    latnew=lat(end:-1:1);
    matrixnew=matrix(:,end:-1:1);
end
