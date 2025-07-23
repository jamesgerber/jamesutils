function [filesWeNeed, raster] = getHansenFromLongLat(long, lat, hansenLayer, varargs)
%GETHANSENFROMLATLONG takes a geographic rectangle (long lat) and finds the minimal
% set of hansen tiles that cover the rectangle
%
%%% Inputs:
%
% long: A vector that must contain the maximum and minimum longitude of the
% rectangle only the max and min of long matter, example [10 20 30]
%
% lat: A vector that must contain the maximum and minimum lattitude of the
% rectangle only the max and min of lat matter, example [10 20 30]
%
% hansenLayer: The string specifing which Hansen tiles you are using, 
% this is appended to the beginning of the string that is looked for, can
% be ''
% 
% varargs: Optional parameter for specifying the directory where the Hansen
% tiles are located
%
%%% Outputs
%
% filesWeNeed: The file names of every Hansen tile used in a matrix 
% raster: A matrix of the raster of every tile from filesWeNeed appended together
%
%
%%% Example:
%
% input: [files, r] = getHansenFromLongLat( [-12 -20],[-40 -30], '', '/Volumes/carlos/HansonData/glad.umd.edu/mapdata/forest_loss_2000to2017')
% output: ["40S_020W.tif", r]
% r in this case is a 40000x40000 raster
%
%
%
% 
% Written By: Sam Stiffman
% Last Modified: 7/8/2019

% Hansen directory
if nargin > 3
    cd(varargs)
end

% Minimums and maximums of the rectangle
longLower = min(long);
longUpper = max(long);
latLower = min(lat);
latUpper = max(lat);

% Round the bounds of the rectangle to the smallest rectangle that is a
% multiple of 10 and contains the rectangle, [10 21] => [10 30]
baseLat = floor(latLower/10)*10;
topLat = ceil(latUpper/10)*10;
baseLong = floor(longLower/10)*10;
topLong = ceil(longUpper/10)*10;
rows = (topLat-baseLat)/10;
columns = (topLong-baseLong)/10;
filesWeNeed = strings(rows, columns);

raster = [];
for row = 1:size(filesWeNeed,1)
    rasterRow = [];
    for column = 1:size(filesWeNeed,2)
        currLat = baseLat+10*(row-2);
        if currLat >= 0
            NS = 'N';
        else
            NS = 'S';
        end
        currLong = baseLong+10*(column-1);
        if currLong >= 0
            EW = 'E';
        else
            EW = 'W';
        end
        currLat = abs(currLat);
        currLong = abs(currLong);
        filesWeNeed(row,column) = sprintf('%s%02i%s_%03i%s.tif',hansenLayer, currLat,NS,currLong,EW);
        [r, ~] = geotiffread(filesWeNeed(row,column));
        rasterRow = [rasterRow r];
    end
    raster = [raster;rasterRow];
end




%Hansen_GFC2014_treecover2000_
