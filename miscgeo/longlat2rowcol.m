function [row,col,vectorindex]=longlat2rowcol(longpos,latpos,Long,Lat)
% longlat2rowcol - convert latitude and longitude to row and column
%
% SYNTAX
%     [row,col,vectorindex]=longlat2rowcol(longpos,latpos) will return the
%     row/col associated with latpos and longpos in 4320x2160 array
%
%     longlat2rowcol(longpos,latpos,Data) will return the row/col
%     associated with latpos and longpos in array Data.
%
%     longlat2rowcol(longpos,latpos,Long,Lat) will return the row/col
%     associated with latpos/longpos in a map of size Lat/Long or of size
%     length(Lat)/length(Long).
%
% NOTE: longlat2rowcol assumes that the samples are evenly distributed even
% if given Lat and Long parameters.
%
% EXAMPLE
%
%  s=opennetcdf([iddstring '/AdminBoundary2010/Raster_NetCDF/3_M3lcover_5min/admin_5min_r2.nc']);
%  [row,col,vectorindex]=longlat2rowcol(1.6358,42.5675,s.Data)
%  S.Data(row,col)
%  S.Data(row,col)
%  should get 10800 (andorra)
%
%     S=testdata(100,50,1);
%     [r,c]=longlat2rowcol(-180,90,S.Long,S.Lat)
%     S.Data(r,c)
%
%
%  Example:
%
%  
%  x=[1 -22.4475 -50.6686; 2 -21.5364 -149.8594;];
%  millnumbers=x(:,1);
%  latvalues=x(:,2);
%  longvalues=x(:,3);
%
%  milllocation=datablank;
%  [row,col,vectorindex]=longlat2rowcol(longvalues,latvalues);
%  milllocation(vectorindex)=millnumbers;


if nargin==0
    help(mfilename)
    return
end

if nargin==2
    Lat=2160;
    Long=4320;
end
if nargin==3
    Lat=size(Long,2);
    Long=size(Long,1);
end
if isscalar(Long)
	tmp=linspace(-1,1,2*Long+1);
    Long=180*tmp(2:2:end).';
end
if isscalar(Lat)
    tmp=linspace(-1,1,2*Lat+1);
    Lat=-90*tmp(2:2:end).';
end
col=zeros(numel(latpos),1);
row=zeros(numel(longpos),1);
for i=1:numel(latpos)
    col(i)=closest(Lat,latpos(i));
    row(i)=closest(Long,longpos(i));
end
vectorindex= (col-1)*numel(Long) + row;

%col=round(((90.0-latpos)/180)*(Lat-1)+1);
%row=round(((longpos+180.0)/360)*(Long-1)+1);
