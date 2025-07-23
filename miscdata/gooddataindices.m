function [ii,croparea,yield]=GoodDataIndices(CS);
% GoodDataIndices - find indices with good yield and area data
%
% SYNTAX
%     ii=GoodDataIndices(CropStructure);
%     [ii,croparea,yield]=GoodDataIndices(CropStructure); where croparea
%     yield have all indices not contained in ii replaced with NaN
%
%
switch nargin
    case 1
        ii=(CS.Data(:,:,1) > 0 & CS.Data(:,:,1) < 9e9 & ...
            CS.Data(:,:,2) > 0 & CS.Data(:,:,2) < 9e9 & ...
            isfinite(CS.Data(:,:,1)) & isfinite(CS.Data(:,:,2)));
        croparea=CS.Data(:,:,1);
        yield=CS.Data(:,:,2);
        
        croparea(~ii)=NaN;
        yield(~ii)=NaN;
    otherwise
        error
end
