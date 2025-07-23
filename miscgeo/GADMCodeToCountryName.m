function countryname=GADMCodeToCountryName(gadmcode);
% GADMCodeToCountryName - return country name

[g0,g1,g2,g3,g]=getgeo41;


tmp=char(gadmcode);

idx=strmatch(tmp(1:3),g0.gadm0codes);

if numel(idx)==0
    error
else
    countryname=g0.namelist0{idx};
end

