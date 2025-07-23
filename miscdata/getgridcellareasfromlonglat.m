function [GridCellAreasha]=getgridcellareasfromlonglat(long,lat);
% GetGridCellAreasFromLongLat determine area in a grid from a long/lat
% vector
%
%  Syntax
%
%      GridCellAreasha=GetGridCellAreasFromLongLat(long,lat);
%
%
%  
%   assumes a perfectly spherical earth of radius 6371km, which is mean
%   radius of earth
%
%  See also   get9secondgridcellareas, getfiveminutegridcellareas, fma



%if ~isoscar
%error
%end


EarthCircumference=6371*2*pi;  %source: wikipedia
xequator=(EarthCircumference)*(abs(mean(diff(long))))/360;
yequator=(EarthCircumference)*(abs(mean(diff(lat))))/360;
xequator*yequator


GridAreaAtEquator=xequator*yequator*1e2; %1e2 is sq km to ha
%


GridCellAreasha=GridAreaAtEquator*single(ones(size(long(:))))*single(cosd(lat(:).'));

