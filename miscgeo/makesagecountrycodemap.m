%[iiRegion,RegionName]=CountryNumToOutline(SageNumber);
map=datablank;

for SageNumber=1:237;
    [iiRegion,RegionName]=CountryNumToOutline(SageNumber);
    map(iiRegion)=SageNumber;
    NameList{SageNumber}=RegionName;
end

SageNumberMap=map;

save([iddstring 'misc/SageNumberCountryMap'],'SageNumberMap','NameList')
