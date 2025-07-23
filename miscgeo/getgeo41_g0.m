function [g0,ii,countryname,ISO]=getgeo41_g0(ISO);
% getgeo41 get harmonized geo data from GADM4.1
%
%  [g0]=getgeo41_g0;
%  [g0]=getgeo41_g0(ISO);
%  [g0,ii]=getgeo41_g0(ISO);
%  [g0,ii,countryname,ISO]=getgeo41_g0(ISO);




persistent savethings

if isempty(savethings) 
    g0=load('/Users/jsgerber/DataProducts/ext/GADM/GADM41/gadm41_level0raster5minVer2.mat');

    g0.raster0lml=g0.raster0(landmasklogical);

    savethings.g0=g0;

else
    
    g0=savethings.g0;

end



if nargin==1
    if isnumeric(ISO)
        ISO=g0.gadm0codes{ISO};
    end
    idx=strmatch(ISO,g0.gadm0codes);
    g0=subsetofstructureofvectors(g0,idx);
end

if nargout>=2 
    if nargin==1
        ii=find(g0.raster0==g0.uniqueadminunitcode);

        idx=strcmp(g0.gadm0codes,ISO);
        countryname=g0.namelist0{idx};

    else
        error
    end
end
