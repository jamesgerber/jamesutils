function [iilong,jjlat]=LatLongIndices(data,site)
% LATLONGINDICES - Long/Lat range for a given country
%
% SYNTAX
% LatLongIndies(data,site) -
% return the long and lat indices bounding a given country, where data is
% used to determine the lat/long resolution and site is the name of the
% country. Currently only accepts 'us' and 'am'.
%

[Nlong,Nlat]=size(data);

long=linspace(-180,180,Nlong);
lat=linspace(90,-90,Nlat);

switch lower(site(1:2))
 case {'us','am'}
  iilong=find(long > -125 & long < -60);
  jjlat=find(lat > 25 & lat < 50);
  
 otherwise
  error('don''t have that region')
end
