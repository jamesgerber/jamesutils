function [isolist,namelist]=ISO_SEAsia;
if nargin==0
    help(mfilename)
end
namelist={'cambodia','vietnam','thailand','laos','indonesia','myanmar','brunei','singapore','malaysia','papua new guinea','sri lanka'};

namelist=unique(namelist)

for j=1:numel(namelist)

S=getcountrycode(namelist{j});
isolist{j}=S.GADM_ISO;
end