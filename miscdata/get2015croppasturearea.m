function [croplandraster,pastureraster]=get2015croppasturearea;
% get get2015croppasturearea  - return Mehrabi et al 2015 cropland and pasture area
%
%   [croplandraster,pastureraster]=get2015croppasturearea;
% 

basedir=[DataProductsDir '/ext/CropPasture2015/global-agland-2015/global-agland-2015/docs/source/_static/img/model_outputs/all_correct_to_FAO_scale_itr3_fr_0/']


[long,lat,croplandraster]=processgeotiff([basedir '/output_3_cropland.tif']);
[long,lat,pastureraster]=processgeotiff([basedir '/output_3_pasture.tif']);

croplandraster(croplandraster>250)=0;
pastureraster(pastureraster>250)=0;
