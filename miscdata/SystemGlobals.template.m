%SystemGlobals% - 




MISSINGDATAVALUE=-9E9;


username=getenv('USER');

switch username
    case {'muell512','cass0131'}
        IoneDataDir=['~/Library/IonE/data/'];
    case 'jsgerber'
        IoneDataDir=['/Library/IonE/data/'];
    otherwise
        IoneDataDir=['/Library/IonE/data/'];
end


ADMINBOUNDARYMAP_5min    =[IoneDataDir 'AdminBoundary2005/Raster_NetCDF/2_States_5min/glctry.nc'];
ADMINBOUNDARYMAP_5min_key=[IoneDataDir 'AdminBoundary2005/Raster_NetCDF/2_States_5min//PolitBoundary_Aug09.csv'];
LANDMASK_5MIN= [IoneDataDir 'LandMask/LandMaskRev1.nc'];
LANDMASK_30MIN= [IoneDataDir 'LandMask/LandMask_30min.nc'];
AREAMAP_5MIN=[IoneDataDir 'misc/area_ha_5min.nc'];

DERIVEDCLIMATEDATAPATH=[IoneDataDir 'Climate/WorldClimDerivedData/'];


WORLDCOUNTRIES_LEVEL0=[IoneDataDir 'AdminBoundary2010/WorldLevel0Coasts_RevAr0.mat'];

WORLDCOUNTRIES_LEVEL0_HIRES=[IoneDataDir 'AdminBoundary2010/WorldLevel0Coasts_RevAr0_HiRes.mat'];
USSTATESBOUNDARY_VECTORMAP_HIRES=[IoneDataDir 'AdminBoundary2010/USStates.mat'];
WORLDCOUNTRIES_BRIC_NAFTASTATES_VECTORMAP_HIRES=[IoneDataDir 'AdminBoundary2010/WorldLevel0Coasts0_bricnafta1_HiRes.mat'];
%% Override settings here


ADMINBOUNDARY_VECTORMAP=WORLDCOUNTRIES_LEVEL0;
ADMINBOUNDARY_VECTORMAP_HIRES=WORLDCOUNTRIES_BRIC_NAFTASTATES_VECTORMAP_HIRES;


switch username
    case 'muell512'
        
    case 'cass0131'

    case 'jsgerber'
        
    case 'dray'

    case 'jfoley'
        
    otherwise

end