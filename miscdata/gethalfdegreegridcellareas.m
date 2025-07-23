function [Long,Lat,HalfDegGridCellAreas]=GetHalfDegreeGridCellAreas(indices);
% GetHalfDegreeGridCellAreas determine area in centered grids that are 30min x 30min
%
%  Syntax
%      [Long,Lat,FiveMinGridCellAreas]=GetHalfDegreeGridCellAreas;
%
%      FiveMinGridCellAreas=GetHalfDegreeGridCellAreas;
%
%
%      FiveMinGridCellAreas=GetHalfDegreeGridCellAreas(ii);  will return the
%      areas evaluated only according to the index matrix ii.  ii may be
%      logical or an array of indices.
%
%   assumes a perfectly spherical earth of radius 6371km, which is mean
%   radius of earth


tmp=linspace(-1,1,2*(4320/6)+1);
Long=180*tmp(2:2:end).';
tmp=linspace(-1,1,2*(2160/6)+1);
Lat=-90*tmp(2:2:end).';

%EarthCircumference=40075;
% EarthCircumference=40024;
EarthCircumference=6371*2*pi;  %source: wikipedia



HalfDegGridAreaAtEquator=EarthCircumference.^2*(1/360/2)^2*1e2; %1e2 is sq km to ha
%
HalfDegGridCellAreasha=HalfDegGridAreaAtEquator*ones(size(Long))*cosd(Lat.');
HalfDegGridCellAreas=HalfDegGridCellAreasha;


if nargout==1
    Long=HalfDegGridCellAreas;
end


if nargout==1 & nargin==1
    Long=HalfDegGridCellAreas(indices);
end

return
