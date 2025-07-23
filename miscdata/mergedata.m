function A=mergedata(background,blon,blat,data,dlon,dlat,method)
% MERGEDATA - pastes one array over another
% 
% SYNTAX
% mergedata(background,blon,blat,data,dlon,dlat), where background is some
% background data like a global land mask, with longitude and latitude
% defined by blon and blat, and data is an array to be pasted on top of it
% with latitude and longitude defined by dlon and dlat, will put data over
% background such that the resulting array will have the same extent and
% same lat-long values as background.
% mergedata(background,blon,blat,data,dlon,dlat,method) will use 2D
% interpolation method 'method'
% mergedata(background,data) will do it without lats and longs if the grids
% are the same size
%
% NOTES
% The extent of data must be within the extent of background. NaNs will be
% treated as transparent and will not be pasted.
%
% EXAMPLES
% countries=OpenNetCDF([iddstring ...
% '/AdminBoundary2010/Raster_NetCDF/1_Countries_0.5deg/ctry_0.5.nc']);
% S=OpenNetCDF([iddstring '/Crops2000/crops/maize_5min.nc']);
% cropgrid=S.Data(:,:,4)+50000;
% cropgrid(cropgrid>999999|cropgrid<50000)=NaN;
% result=mergedata(countries.Data,countries.Long,countries.Lat, ...
% cropgrid,S.Long,S.Lat,'linear');
%

if nargin==2
    tmp=background;
    background=blon;
    background(isnan(background))=tmp(isnan(background));
    A=background;
    return
end
if (nargin<7)
    method='nearest';
end
[~,ilon1]=nearestelement(blon,min(dlon));
[~,ilon2]=nearestelement(blon,max(dlon));
numlon=abs(ilon1-ilon2)+1;
[~,ilat1]=nearestelement(blat,min(dlat));
[~,ilat2]=nearestelement(blat,max(dlat));
numlat=abs(ilat1-ilat2)+1;
data=EasyInterp2(data,numlon,numlat,method);
if (ilon1>ilon2)
    tmp=ilon1;
    ilon1=ilon2;
    ilon2=tmp;
end
if (ilat1>ilat2)
    tmp=ilat1;
    ilat1=ilat2;
    ilat2=tmp;
end
tmp=background;
background(ilon1:ilon2,ilat1:ilat2)=data;
background(isnan(background))=tmp(isnan(background));
A=background;