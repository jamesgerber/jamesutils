function MergeCropLayers(cropname,NewArea,NewYield,Year,DAS);
% MergePerturbedCropLayers - combines area / yield into a new data layer

if nargin < 5
    DAS=struct;
end

S=getdata(cropname);
DAS.missing_value=S.missing_value;
S.Data(:,:,1)=NewArea;
S.Data(:,:,2)=NewYield;


DAS.Description=['Perturbed crop data for ' int2str(Year) ];
DAS.BaseYear='2000';

NewFileName=[cropname '_5min_Y' int2str(Year) ];

WriteNetCDF(S.Long,S.Lat,S.Data,cropdata,NewFileName,DAS);


return


a=dir('Y*nc')
for j=1:length(a)
    tmp=a(j).name;
    thiscrop=tmp(6:end-3)

areafile=OpenNetCDF(['Hectare2005' thiscrop]);
yieldfile=OpenNetCDF(a(j).name);
DAS.origfiledate=a(j).date;
DAS.areaversion=areafile.version;
DAS.yieldversion=yieldfile.version;
MergePerturbedCropLayers(cropname,areafile.Data,yieldfile.Data,2005);
end


