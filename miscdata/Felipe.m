
function correctRaster = Felipe(raster)
% Felipe - takes a raster of the earth and makes sure it is the correct
% orientation for thinsurf to display it correctly
% 
%
% Examples:  
% If the code is working correctly the 8 thinsurf results should all come
% out the same, the tests use the 5min and 10min landmasklogical maps
%
% x = landmasklogical();
% xbad1 = flip(x);     %%% Upside down map
% xbad2 = fliplr(x);   %%% Flipped Map
% xbad3 = flip(xbad2); %%% Map that is flipped and upsidedown
% thinsurf(Felipe(x));
% thinsurf(Felipe(xbad1))
% thinsurf(Felipe(xbad2))
% thinsurf(Felipe(xbad3))
% 
% x = landmasklogical(ones(2160, 1080));
% xbad1 = flip(x);     %%% Upside down map
% xbad2 = fliplr(x);   %%% Flipped Map
% xbad3 = flip(xbad2); %%% Map that is flipped and upsidedown
% thinsurf(Felipe(x))
% thinsurf(Felipe(xbad1))
% thinsurf(Felipe(xbad2))
% thinsurf(Felipe(xbad3))
%
% Written by Sam Stiffman
% Original:   1/7/2019
% Last Edit:  9/17/2019


%%%%%% Constants do not change %%%%%%

RASTER_10_MINUTES = ones(2160, 1080);
FLIPPED_ONE_DEGREE_SIZE = [180 360];
ONE_DEGREE_SIZE = [360 180];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rasterSize = size(raster);
resolution = detectResolution(raster);
oneDegreeSize = rasterSize * resolution;

%Raster must be a raster of the earth 
assert(isequal(oneDegreeSize, ONE_DEGREE_SIZE) || isequal(oneDegreeSize, FLIPPED_ONE_DEGREE_SIZE));

%if its up or down transpose the matrix
if rasterSize(2) > rasterSize(1)
    raster = raster.'; 
end

%See what value water is in the map since long lat 0,0 is always water 
waterValue = raster(end/2, end/2);

% make water 0 all over the map if it is not already
if waterValue ~= 0
    indexesOfWater = (raster == waterValue);
    tempRaster = raster;
    tempRaster(indexesOfWater) = 0;
else
    tempRaster=raster;
end
% tempRaster = raster;
% To figure out what orientation match the map with a logical earth map at
% each orientation and see which one matches best
% The way this works is the landmaskLogical will 0 out any value that
% does not match with the map we are working with, this will mean the array with
% the maximum amount of values will be the best match, because this one has
% the most land 
% correctLogical = landmasklogical(RASTER_10_MINUTES);
% 

correctLogical = landmasklogical(raster);
    upsideDown = fliplr(correctLogical);
    flippedUpsidedown = flip(upsideDown);
    flippedNormal = flip(correctLogical);
    
    % Temporary matrices to see how many values are left when compared to
    % the landmask map
    % CO -> correct orientation
    % UD -> upsidedown
    % FCO -> Flipped CO map,
    % FUD -> flipped UD map 
    CO = tempRaster(correctLogical);
    UD = tempRaster(upsideDown);
    FCO = tempRaster(flippedNormal);
    FUD = tempRaster(flippedUpsidedown);
    % S prefix is a sum of all matching values 
    % We take the absolute value so when we take the max negative values
    % dont mess anything up
    SCO = sum(abs(CO));
    SUD = sum(abs(UD));
    SFCO = sum(abs(FCO));
    SFUD = sum(abs(FUD));
    
    arrayOfSums = [SCO SUD SFCO SFUD];
   
    if max(arrayOfSums) == SCO
        % Map is correct orientation no need for an operation
        correctRaster = raster; 
    elseif max(arrayOfSums) == SUD
        correctRaster = fliplr(raster);
    elseif max(arrayOfSums) == SFCO
        correctRaster = flip(raster);
    elseif max(arrayOfSums) == SFUD
        correctRaster = flip(fliplr(raster));
    else
        error('MATLAB:arguments:InconsistentDataType', 'Raster not map of Earth');
    end
end

function resolution = detectResolution(raster)

%%%% Constants do not modify %%%%%
RESOLUTION_5_MIN = 1/12;
FIVE_MINUTE_SIZE = [2160 4320];
FLIPPED_FIVE_MINUTE_SIZE = [4320 2160]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rasterSize = size(raster);


% Correct orientation of the earth
if rasterSize(2) > rasterSize(1)
    rasterMod5Minutes = mod(rasterSize, FIVE_MINUTE_SIZE);
    fiveMinutesModRaster = mod(FIVE_MINUTE_SIZE, rasterSize);
    
    %Check if they are multiples
    if ~rasterMod5Minutes
        scalingFactor = rasterSize ./ FIVE_MINUTE_SIZE;
        scalingFactor = scalingFactor(1);
    elseif ~fiveMinutesModRaster
        scalingFactor = FIVE_MINUTE_SIZE ./ rasterSize;
        scalingFactor = scalingFactor(1);
    else
        error('MATLAB:arguments:InconsistentDataType', ['Raster must have dimensions that are an integer multiple of 2160x4320 current dimensions: ' num2str(rasterSize)]);
    end
% Incorrect orientation of the earth
elseif rasterSize(1) > rasterSize(2)
    
    rasterMod5Minutes = mod(rasterSize, FLIPPED_FIVE_MINUTE_SIZE);
    fiveMinutesModRaster = mod(FLIPPED_FIVE_MINUTE_SIZE, rasterSize);
    
    if ~rasterMod5Minutes
        scalingFactor = rasterSize ./ FLIPPED_FIVE_MINUTE_SIZE;
        scalingFactor = scalingFactor(1);
    elseif ~fiveMinutesModRaster
        scalingFactor = FLIPPED_FIVE_MINUTE_SIZE ./ rasterSize;
        scalingFactor = scalingFactor(1);
    else
        error('MATLAB:arguments:InconsistentDataType', ['Raster must have dimensions that are an integer multiple of 2160x4320 current dimensions: ' num2str(rasterSize)]);
    end
else
    error('MATLAB:arguments:InconsistentDataType', 'Raster not map of Earth');
end    

resolution = RESOLUTION_5_MIN*scalingFactor;
end
