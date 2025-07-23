%[iiRegion,RegionName]=CountryNumToOutline(SageNumber);
map=datablank;
testmap=datablank;

ContinentList={'Africa',...
    {'Western Europe','Northern Europe','Southern Europe'},...
'Australia and New Zealand',...
'Eastern Europe',...
'Asia',...
{'South America','Central America'}...
'North America',...
 {'Melanesia','Micronesia','Polynesia'}};
NameList=ContinentList;
NameList{2}='Western Europe';
NameList{6}='South and Central America';
NameList{4}='Eastern Europ (incl. former USSR)'
NameList{8}='Oceania';

for cn=1:8;
    
    ContinentName=ContinentList{cn};
    iiRegion=ContinentOutline(ContinentName);
            
    map(iiRegion)=cn;
    testmap(iiRegion)=testmap(iiRegion)+ones(size(cn));
   % NameList{cn}=ContinentName;
end




ContinentMap=map;

save([iddstring 'misc/ContinentMap'],'ContinentMap','NameList','testmap')
