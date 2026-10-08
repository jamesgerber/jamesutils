function [croplandraster,pastureraster,croplandrasternan,pasturerasternan]=get2015croppasturearea;
% get get2015croppasturearea  - return Mehrabi et al 2015 cropland and pasture area
%
%   [croplandraster,pastureraster]=get2015croppasturearea;
%   [croplandraster,pastureraster,croplandrasternan,pasturerasternan]=get2015croppasturearea
%   (for backwards compatibility)
% 


[long,lat,croplandraster]=processgeotiff('~/shareddrives/GeospatialDrive/ProcessedData/Landcover/MehrabiCropPastureArea2015/cropland2015.tif');
[long,lat,pastureraster]=processgeotiff('~/shareddrives/GeospatialDrive/ProcessedData/Landcover/MehrabiCropPastureArea2015/pasture2015.tif');

croplandrasternan=croplandraster;
pasturerasternan=pastureraster;

croplandraster(isnan(croplandraster))=0;
pastureraster(isnan(pastureraster))=0;
