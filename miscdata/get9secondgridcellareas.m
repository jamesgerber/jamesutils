function [Longout,Latout,NineSecGridCellAreasha]=get9secondgridcellareas(varargin);
% Get9secondGridCellAreas determine area in centered grids that are 5min x 5min
%
%  Syntax
%      [Long,Lat,FiveMinGridCellAreas]=Get9secondGridCellAreas;
%
%      FiveMinGridCellAreas=GetFiveMinGridCellAreas;
%
%      FiveMinGridCellAreas=GetFiveMinGridCellAreas(long,lat);
%
%
%      FiveMinGridCellAreas=GetFiveMinGridCellAreas(ii);  will return the
%      areas evaluated only according to the index matrix ii.  ii may be
%      logical or an array of indices.
%
%   assumes a perfectly spherical earth of radius 6371km, which is mean
%   radius of earth




%if ~isoscar
%error
%end


tmp=linspace(-1,1,2*129600+1);
Long=180*tmp(2:2:end).';
tmp=linspace(-1,1,2*64800+1);
Lat=-90*tmp(2:2:end).';
%EarthCircumference=40075;
% EarthCircumference=40024;
EarthCircumference=6371*2*pi;  %source: wikipedia



NineSecGridAreaAtEquator=single(EarthCircumference.^2/(129600)^2*1e2); %1e2 is sq km to ha
%

if nargout==1 && nargin==2
    longvals=varargin{1};
    latvals=varargin{2};
    Longout=NineSecGridAreaAtEquator*single(ones(size(longvals(:))))*single(cosd(latvals(:).'));
return
end


NineSecGridCellAreasha=NineSecGridAreaAtEquator*single(ones(size(Long)))*single(cosd(Lat.'));


Longout=Long;
Latout=Lat;

if nargout==1
    Longout=NineSecGridCellAreasha;
end


if nargout==1 && nargin==1
    indices=varargin{1};
    Longout=NineSecGridCellAreasha(indices);    
end


return
