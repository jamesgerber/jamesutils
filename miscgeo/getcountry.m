
function [CountryNumbers,CountryNames,longlist,latlist]=GetCountry5min(longlist,latlist);
% GETCOUNTRY - get country numbers and names from long/lat
%
% SYNTAX
%   [CountryNumbers,CountryNames]=GetCountry5min(longlist,latlist);
%
%   [CountryNumbers,CountryNames,LongList,LatList]=GetCountry5min(IndexList);  IndexList can
%   be a list of indices into a 5minute grid of the world.
%
%  
%
%  This code is based on two files provided by Navin Ramankutty:
%    glctry.nc           -  netcdf format grid with lat/long/country code
%    Polit.BdryCode.xls  -  text file with country code / country name
%
%  This code works by cycling through the list of longitude and
%  latitude, and for each long/lat pair, it finds the closest
%  long/lat in the glctry.nc data, and gets the country code for
%  that long/lat point.  the country code is occasionally 0, in
%  which case CountryNames is assigned the value "Ocean"
%
%  Example
% longlist=[-100 -100  0 0 -30];
% latlist=[40  60 51.5 10 40];
%[CountryNumbers,CountryNames]=GetCountry5min(longlist,latlist)


if nargin==0
  help(mfilename);return;
end


%  Call systemglobals to find default (and possibly user-specific) paths
try
  SystemGlobals
catch
    disp([' Didn''t find SystemGlobals.  ']);
    ADMINBOUNDARYMAP_5min    ='/Library/IonE/data/AdminBoundary/glctry.nc';
end


ncid=netcdf.open(ADMINBOUNDARYMAP_5min,'NOWRITE');
netcdf.inqVar(ncid,0);

long=netcdf.getVar(ncid,0);
lat=netcdf.getVar(ncid,1);
level=netcdf.getVar(ncid,2);
time=netcdf.getVar(ncid,3);
ctry=netcdf.getVar(ncid,4);
ctry=double(ctry);


if nargin==1
    indexlist=longlist;
    %need to turn single input list of indices into a list of long and lat.
    [long2d,lat2d]=meshgrid(lat,long);
    
    longlist=long2d(indexlist);
    latlist=lat2d(indexlist);
end




[NumList,NameList,UnitNames]=LoadPolitBoundary_5min;



%% possibly need to correct longlist, latlist if we are using the mapping
%% toolbox.
% % try
% %     CanMap=CheckForMappingToolbox;
% %     if CanMap==1;
% %         longlist=longlist*(180/pi);
% %         latlist=latlist*(90/pi);
% %     end
% % catch
% %     disp(['problem with Mapping Toolbox check in ' mfilename])
% % end





for j=1:length(longlist);
  ilong=iclosest(long,longlist(j));
  ilat=iclosest(lat,latlist(j));  
  CountryNumbers(j)=ctry(ilong,ilat);
  % now look up num, name
  

  if CountryNumbers(j)==0;
      CountryNames{j}='ocean';
  else
      ii=find(NumList==CountryNumbers(j));
      CountryNames{j}=NameList{ii};
  end
  
end
 
