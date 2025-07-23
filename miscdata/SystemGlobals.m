%SystemGlobals% -

% Loads important files in IoNE Data directory for mapping
% Look for file localMatlabPaths.m in path
% if not found uses default ~/ionedata/


% Check for localMatlabPath.m file
if exist("localMatlabPath.m", 'file')
   IoneDataDir = localMatlabPath;
else
   IoneDataDir='~/ionedata/';
   warning('localMatlabPath not found in path, IoneDataDir set to ~/ionedata/')
end

MISSINGDATAVALUE=-9E9;

ADMINBOUNDARYMAP_5min    =[IoneDataDir 'AdminBoundary2010/Raster_NetCDF/2_States_5min/glctry.nc'];
ADMINBOUNDARYMAP_5min_key=[IoneDataDir 'AdminBoundary2010/Raster_NetCDF/2_States_5min//PolitBoundary_Aug09.csv'];
LANDMASK_5MIN= [IoneDataDir 'LandMask/LandMaskRev1.nc'];
LANDMASK_30MIN= [IoneDataDir 'LandMask/LandMask_30min.nc'];
AREAMAP_5MIN=[IoneDataDir 'misc/area_ha_5min.nc'];

DERIVEDCLIMATEDATAPATH=[IoneDataDir 'Climate/WorldClimDerivedData/'];


WORLDCOUNTRIES_LEVEL0=[IoneDataDir 'AdminBoundary2010/WorldLevel0Coasts_RevAr0.mat'];

WORLDCOUNTRIES_LEVEL0_HIRES=[IoneDataDir 'AdminBoundary2010/WorldLevel0Coasts_RevAr0_HiRes.mat'];
WORLDCOUNTRIES_LEVEL1_HIRES=[IoneDataDir 'AdminBoundary2010/WorldLevel1_HiRes_RevAr0.mat'];

USSTATESBOUNDARY_VECTORMAP_HIRES=[IoneDataDir 'AdminBoundary2010/USStates.mat'];
WORLDCOUNTRIES_BRIC_NAFTASTATES_VECTORMAP_HIRES=[IoneDataDir 'AdminBoundary2010/WorldLevel0Coasts0_bricnafta1_HiRes.mat'];
%% Override settings here


ADMINBOUNDARY_VECTORMAP=WORLDCOUNTRIES_LEVEL0;
ADMINBOUNDARY_VECTORMAP_HIRES=WORLDCOUNTRIES_BRIC_NAFTASTATES_VECTORMAP_HIRES;


%%%% Old Version Deprecated

%   if(ismac)
%       username = getenv('USER');
%   else
%       username = getenv('username');
%   end
% switch username
%     case 'muell512'
% 
%     case 'cass0131'
% 
%     case 'jsgerber'
%         ADMINBOUNDARYMAP_5min    =[IoneDataDir 'AdminBoundary2005/Raster_NetCDF/2_States_5min/glctry.nc'];
%         ADMINBOUNDARYMAP_5min_key=[IoneDataDir 'AdminBoundary2005/Raster_NetCDF/2_States_5min//PolitBoundary_Aug09.csv'];
% 
%     case 'dray'
% 
%     case 'jfoley'
% 
%     otherwise
% 
% end
% switch username

%     case 'lsloat'
%         IoneDataDir=['~/ionedata/'];
%     case {'muell512','cass0131','oconn568'   }
%         IoneDataDir=['~/Library/IonE/data/'];
%     case {'kbrauman'}
%         IoneDataDir=['/Library/IonEdata/'];
%     case {'emilydombeck','carlsonk'}
%         IoneDataDir='~/Library/ionedata/';
%     case 'jsgerber'
%         IoneDataDir=['~/Public/ionedata/'];
%     case 'sunx0170'
%         IoneDataDir=['~/Program/ionedata/'];
%     case 'oggxx008'
%         IoneDataDir='~/ionedata/';
%     case 'mattj'
%         IoneDataDir=['C:\Users\mattj\Documents\UMN\ionedata\'];
%     case 'pcwest'
%         IoneDataDir= '~/Data/';
%     otherwise
%         IoneDataDir=['/ionedata/'];
% end
% 
% if ispc==1
%     %& isequal(getenv('username'),'engs0074')
%     IoneDataDir=['C:\GLI\MATLAB\data\'];
% end
% 
% 
% if ismac==1 & ismalthus==1
%    IoneDataDir=['/ionedata/'];
% end