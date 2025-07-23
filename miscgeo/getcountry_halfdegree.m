function [CountryNumbers,CountryNames]=GetCountry(longlist,latlist);
% GETCOUNTRY - get country numbers and names from long/lat
%
% SYNTAX
%   [CountryNumbers,CountryNames]=GetCountry(longlist,latlist);
%
%  This code is based on two files provided by Navin Ramankutty:
%    ctry_0.5.nc   -  netcdf format grid with lat/long/country code
%    ctry.dat      -  text file with country code / country name
%
%  This code works by cycling through the list of longitude and
%  latitude, and for each long/lat pair, it finds the closest
%  long/lat in the ctry_0.5.nc data, and gets the country code for
%  that long/lat point.  the country code is occasionally 0, in
%  which case CountryNames is assigned the value "Ocean"
%
%  Example
% longlist=[-100 -100  0 0 -30];
% latlist=[40  60 51.5 10 40];
%[CountryNumbers,CountryNames]=GetCountry(longlist,latlist)


if nargin==0
  help(mfilename);return;
end

SystemGlobals
ncid=netcdf.open([IoneDataDir '/AdminBoundary2005/Raster_NetCDF/1_Countries_0.5deg/ctry_0.5.nc'],'NOWRITE');

long=netcdf.getVar(ncid,0);
lat=netcdf.getVar(ncid,1);
level=netcdf.getVar(ncid,2);
time=netcdf.getVar(ncid,3);
ctry=netcdf.getVar(ncid,4);
ctry=double(ctry);


newdata=importdata([IoneDataDir '/AdminBoundary2005/Raster_NetCDF/1_Countries_0.5deg/ctry.dat']);
for j=1:length(newdata)
thisline=newdata{j};
ii=findstr(thisline,'0 ');
NumList(j)=str2num(thisline(1:ii));
NameList{j}=strrep(thisline(ii+1:end),' ','');
end



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
 
