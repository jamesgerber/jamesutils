function [latpos,longpos]=RowCol2LatLong(row,col,Lat,Long)
% LatLong2RowCol - convert row and column to latitude and longitude
%
% SYNTAX
%     RowCol2LatLong(row,col,Data) will return the lat/long
%     associated with row and col in array Data.
%
%     RowCol2LatLong(row,col,Lat,Long) will return the lat/long
%     associated with row/col in a map of size Lat/Long or of size
%     length(Lat)/length(Long).
%
% EXAMPLE
% [latpos,longpos]=RowCol2LatLong(5,4,10,20);
%
if nargin==2
    Lat=2160;
    Long=4320;
end
if nargin==3
    Long=max(size(Lat));
    Lat=min(size(Lat));
end
if isscalar(Long)
    tmp=linspace(-1,1,2*Long+1);
    Long=180*tmp(2:2:end).';
end
if isscalar(Lat)
    tmp=linspace(-1,1,2*Lat+1);
    Lat=-90*tmp(2:2:end).';
end
latpos=Lat(col);
longpos=Long(row);