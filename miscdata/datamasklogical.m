function LogicalVector=DataMaskLogical(DataTemplate);
% DATAMASKLOGICAL - logical array of standard (5 min) datamask
% 
% SYNTAX
% DataMaskLogical(DataTemplate) - return the logical data mask fitting
% DataTemplate.  If DataTemplate is unspecified, return 5min data mask.
persistent DataLandMaskVector

if isempty(DataLandMaskVector)
    SystemGlobals
    [Long,Lat,Data]=OpenNetCDF(LANDMASK_5MIN);
    DataLandMaskVector=(Data>2);
end
LogicalVector=DataLandMaskVector;


if nargin==0
    return
end

% if we are here, it is because a DataTemplate was passed in.

switch numel(DataTemplate)
    case 4320*2160  %5min
        return
    case 2160*1080  %10min

        ii=1:2:4319;
        jj=1:2:2159;
      
        LogicalVector10min=...
            (LogicalVector(ii,jj)  | ...
            LogicalVector(ii,jj+1) | ...
            LogicalVector(ii+1,jj) | ...
            LogicalVector(ii+1,jj+1));
        
        LogicalVector=LogicalVector10min;
    otherwise
        EasyInterp2(LogicalVector,size(DataTemplate,1),size(DataTemplate,2));
end





