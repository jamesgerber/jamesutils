function [row,col]=LatLong2RowCol(latpos,longpos,Lat,Long)
% LatLong2RowCol - convert latitude and longitude to row and column
%
% SYNTAX
%     LatLong2RowCol(latpos,longpos,Data) will return the row/col
%     associated with latpos and longpos in array Data.
%
%     LatLong2RowCol(latpos,longpos,Lat,Long) will return the row/col
%     associated with latpos/longpos in a map of size Lat/Long or of size
%     length(Lat)/length(Long).
%
% NOTE: LatLong2RowCol assumes that the samples are evenly distributed even
% if given Lat and Long parameters.
%
% EXAMPLE
%     S=testdata(100,50,1);
%     [r,c]=LatLong2RowCol(90,-180,S.Lat,S.Long)
%     S.Data(r,c)


if nargin==2
    Lat=2160;
    Long=4320;
end
if nargin==3
    Long=size(Lat,1);
    Lat=size(Lat,2);
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
%col=round(((90.0-latpos)/180)*(Lat-1)+1);
%row=round(((longpos+180.0)/360)*(Long-1)+1);
