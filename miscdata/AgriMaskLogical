function LogicalVector=DataMaskLogical;
% DATAMASKLOGICAL -  logical array of standard (5 min) landmask

persistent DataLandMaskVector

if isempty(DataLandMaskVector)
    SystemGlobals
    [Long,Lat,Data]=OpenNetCDF(LANDMASK_5MIN);
    DataLandMaskVector=(Data==7);
end
LogicalVector=DataLandMaskVector;



