function [name]=countrycodetoname(XXX);
%
%
persistent gadm0codes namelist0
if isempty(namelist0)
load('~/DataProducts/ext/GADM/GADM41/gadm41_level0raster5minVer0.mat','gadm0codes','namelist0');
end

switch XXX
    case 'ROM'
        XXX='ROU';
    case 'HKG'
        name='Hong Kong';
        return
        

end


idx=strmatch(XXX,gadm0codes);
Xname=namelist0{idx};


