function [UnitCodes,IDNames,UnitNames,CountryNames,CountryNumbers]=LoadPolitBoundary_5min;
%LOADPOLITBOUNDARY_5MIN - Load country codes and names
%
%
%  SYNTAX:
%
%   [UnitCodes,IDNames,UnitNames,CountryNames,CountryNumbers]=...
%  LoadPolitBoundary_5min;
%
%  This loads the political boundary names associated with the file
%  glctry.nc which was provided by Navin Ramankutty (for reference:
%  ADMINBDRY/Raster_NetCDF/2_States_5min/)
%

try
    SystemGlobals
catch
    disp([' Didn''t find SystemGlobals.  ']);
    ADMINBOUNDARYMAP_5min    ='/Library/IonE/data/AdminBoundary/glctry.nc';
    ADMINBOUNDARYMAP_5min_key='/Library/IonE/data/AdminBoundary/PolitBoundary_Aug09.csv';
end

fid=fopen(ADMINBOUNDARYMAP_5min_key);

if fid==-1
    error(['Did not find file ' ADMINBOUNDARYMAP_5min_key]);
end

C=textscan(fid,'%f%s','Delimiter',',','HeaderLines',1);
fclose(fid);
UnitCodes=C{1};
UnitNames=C{2};



for j=1:length(UnitNames);
    Code=UnitCodes(j);
    
    % does Code end in 00?  if yes, it's a country
    
    FirstThreeDigits=floor(Code/100);
    
    CountryNumbers(j)=FirstThreeDigits;
    
    if isequal(Code,FirstThreeDigits*100)
        CountryCodes{j}=UnitNames{j};
        CountryNames{j}=UnitNames{j};
        
    else
        ThisCountryName=LookUpTable(FirstThreeDigits);
        CountryCodes{j}=[UnitNames{j} ', ' ThisCountryName ];
        CountryNames{j}=ThisCountryName;
    end
    
end

IDNames=CountryCodes;

%%%%%%%%%%%%%%%%%%
% LOOKUPTABLE    %
%%%%%%%%%%%%%%%%%%
function Name=LookUpTable(FirstThreeDigits)
% LOOK UP COUNTRY NAMES
switch FirstThreeDigits
    case 102
        Name='Canada';
    case 111
        Name='Mexico';
    case 115
        Name='USA';
    case 201
        Name='Argentina';
    case 203
        Name='Brasil';
    case 415
        Name='China';
    case 429
        Name='India';
    case 501
        Name='Australia';
    otherwise
        error
end
