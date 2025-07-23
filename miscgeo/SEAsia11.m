function [ISOlist,CountryNameList,iilist,iimap]=SEAsia11(m);
% SEAsia11 - return
%
% [ISOlist,CountryNameList,iilist,iimap]=SEAsia11;
% [ISO,CountryName,ii,iimap]=SEAsia11(m);

ISOlist={'BRN',...
'KHM',...
'IDN',...
'LAO',...
'MMR',...
'MYS',...
'PHL',...
'SGP',...
'THA',...
'TLS',...
'VNM'};

%CountryNames=
g0=getgeo41_g0;

iimap=datablank;

for j=1:numel(ISOlist);
    idx=strcmp(ISOlist{j},g0.gadm0codes);
    CountryNameList{j}=g0.namelist0{idx};
    ii=g0.raster0==find(idx);
    iimap=iimap+ii;
    iilist{j}=find(ii);
end

if nargin==1

    if m==0;
        ISOlist='SEAsia';
        CountryNameList='SoutheastAsia';
        iilist=find(iimap);
        return
    end

    ISOlist=ISOlist{m};
    CountryNameList=CountryNameList{m};
    iilist=iilist{m};




end

