function [Outline,CountryNameList]=ContinentOutline(ContinentList)
%  ContinentOutline - return outline of continents
%
%  SYNTAX
%     Outline=ContinentOutline(ContinentName)
%
%     [Outline,CountryNameList]=ContinentOutline(ContinentName);
%   
%    where ContinentName can be one of the names below.
%   EXAMPLES
%  Outline=ContinentOutline({'Africa'});
%  Outline=...
%  ContinentOutline({'Western Europe','Northern Europe','Southern Europe'});
%
%
%     'Africa'
%    'Americas'
%    'Antartica'
%    'Asia'
%    'Europe'
%    'Oceania'
%
%    'Antartica'
%    'Australia and New Zealand'
%    'Caribbean'
%    'Central America'
%    'Central Asia'
%    'Eastern Africa'
%    'Eastern Asia'
%    'Eastern Europe'
%    'Melanesia'
%    'Micronesia'
%    'Middle Africa'
%    'Northern Africa'
%    'Northern America'
%    'Northern Europe'
%    'Polynesia'
%    'South America'
%    'South-Eastern Asia'
%    'Southern Africa'
%    'Southern Asia'
%    'Southern Europe'
%    'Western Africa'
%    'Western Asia'
%    'Western Europe'

if nargin==0
        help(mfilename)
        return
end
if ischar(ContinentList)
    ContinentList={ContinentList};
end
if length(ContinentList)==1
    ContinentName=ContinentList;
    if iscell(ContinentName)
        ContinentName=ContinentName{1};
    end
else
    ii=datablank;
    [TempOutline,TempNameList]=ContinentOutline(ContinentList(1));
    [TempOutline2,TempNameList2]=ContinentOutline(ContinentList(2:end));
    Outline=TempOutline | TempOutline2;
    CountryNameList=[TempNameList(:)' TempNameList2(:)'];
    return
end

switch ContinentName
    case 'North America'
        ContinentName='Northern America';
end


load([iddstring '/misc/ContinentOutlineData.mat'])

ii=strmatch(ContinentName,UNREGION2,'exact');

if isempty(ii)   
    ii=strmatch(ContinentName,UNREGION1,'exact');
    if isempty(ii)       
        disp(['try '])
        unique(UNREGION2),unique(UNREGION1)
        error(['Don''t know ' ContinentName ])
    end
end

Outline=datablank;
CountryNameList={};
for j=1:length(ii)
    
    FAO=NAME_FAO(ii(j));
    if isempty(FAO{1})
        disp(['ignoring ' NAME_ISO(ii(j))]);
    else
        S3=StandardCountryNames(FAO,'NAME_FAO','sage3');
        if isempty(S3{1})
            disp(['ignoring ' FAO])
        else
            Outline=Outline | CountryCodetoOutline(S3{1});
            CountryNameList(end+1)=FAO;
        end
    end
end

return


%% here is code used to generate ContinentOutlineData
load gadm1_lev0
for j=1:248;
    UNREGION1{j}=S(j).UNREGION1;
    UNREGION2{j}=S(j).UNREGION2;
    NAME_ISO{j}=S(j).NAME_ISO;
    NAME_FAO{j}=S(j).NAME_FAO;
    WBREGION{j}=S(j).WBREGION;
end

save ContinentOutlineData NAME_FAO NAME_ISO UNREGION1 UNREGION2

%% here is some code from Nathan to modify the outputs 
% construct regional outline maps

 

outline_oceaniaseasia = ContinentOutline({'Polynesia', ...
    'Australia and New Zealand','Melanesia','Micronesia','South-Eastern Asia'});

outline_latinamericacarib = ContinentOutline({'South America','Caribbean', ...
    'Central America'});

outline_UScanada = ContinentOutline({'Northern America'});
outline_southasia = ContinentOutline({'Southern Asia'});

outline_mideastnorthafrica = ContinentOutline({'Northern Africa', ...
    'Western Asia'});% note: includes Turkey and Sudan

outline_ssafrica = ContinentOutline({'Southern Africa', ...
    'Western Africa','Middle Africa','Eastern Africa'});

outline_westerneurope = ContinentOutline({'Western Europe', ...
    'Northern Europe','Southern Europe'});

outline_easterneuropeFSU = ContinentOutline({'Eastern Europe',...
    'Central Asia'});

outline_eastasia = ContinentOutline({'Eastern Asia'})
 

% make some modifications:

% transfer Sudan to Sub-Saharan Africa

outline = CountryCodetoOutline('SDN');
outline_mideastnorthafrica(outline == 1) = 0;
outline_ssafrica(outline == 1) = 1;
% transfer Estonia, Latvia, and Lithuania to Eastern Europe from Western

% Europe
outline = CountryCodetoOutline({'LTU','EST','LVA'});
outline_westerneurope(outline == 1) = 0;
outline_easterneuropeFSU(outline == 1) = 1; 