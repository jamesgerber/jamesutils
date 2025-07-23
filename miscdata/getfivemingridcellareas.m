function [Longout,Latout,FiveMinGridCellAreasout]=GetFiveMinGridCellAreas(indices);
% GetFiveMinGridCellAreas determine area in centered grids that are 5min x 5min
%
%  Syntax
%      [Long,Lat,FiveMinGridCellAreas]=GetFiveMinGridCellAreas;
%
%      FiveMinGridCellAreas=GetFiveMinGridCellAreas;
%
%
%      FiveMinGridCellAreas=GetFiveMinGridCellAreas(ii);  will return the
%      areas evaluated only according to the index matrix ii.  ii may be
%      logical or an array of indices.
%
%   assumes a perfectly spherical earth of radius 6371km, which is mean
%   radius of earth

persistent FiveMinGridCellAreas Long Lat

if isempty(FiveMinGridCellAreas);
    
    
    
    tmp=linspace(-1,1,2*4320+1);
    Long=180*tmp(2:2:end).';
    tmp=linspace(-1,1,2*2160+1);
    Lat=-90*tmp(2:2:end).';
    %EarthCircumference=40075;
    % EarthCircumference=40024;
    EarthCircumference=6371*2*pi;  %source: wikipedia
    
    
    
    FiveMinGridAreaAtEquator=EarthCircumference.^2*(1/360/12)^2*1e2; %1e2 is sq km to ha
    %
    FiveMinGridCellAreasha=FiveMinGridAreaAtEquator*ones(size(Long))*cosd(Lat.');
    FiveMinGridCellAreas=FiveMinGridCellAreasha;

end
Longout=Long;
Latout=Lat;

if nargout==1
    Longout=FiveMinGridCellAreas;
end


if nargout==1 & nargin==1
    Longout=FiveMinGridCellAreas(indices);
end
FiveMinGridCellAreasout=FiveMinGridCellAreas;
return
