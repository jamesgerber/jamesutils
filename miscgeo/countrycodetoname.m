function [name]=countrycodetoname(XXX);
%
%
load('/ionedata/AdminBoundary2020/gadm36_level0raster5minVer0.mat','gadm0codes','namelist0');

switch XXX
    case 'ROM'
        XXX='ROU';
end


idx=strmatch(XXX,gadm0codes);
name=namelist0{idx};


