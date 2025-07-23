function argout = CorrectMapOrientation(argin)
% Wrapper for Felipe
% CorrectMapOrientation - takes a raster of the earth and makes sure it is the correct
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
% thinsurf(CorrectMapOrientation(x));
% thinsurf(CorrectMapOrientation(xbad1))
% thinsurf(CorrectMapOrientation(xbad2))
% thinsurf(CorrectMapOrientation(xbad3))
% 
% x = landmasklogical(ones(2160, 1080));
% xbad1 = flip(x);     %%% Upside down map
% xbad2 = fliplr(x);   %%% Flipped Map
% xbad3 = flip(xbad2); %%% Map that is flipped and upsidedown
% thinsurf(CorrectMapOrientation(x))
% thinsurf(CorrectMapOrientation(xbad1))
% thinsurf(CorrectMapOrientation(xbad2))
% thinsurf(CorrectMapOrientation(xbad3))
%
% Written by Sam Stiffman
% Last Edited 1/7/2019

argout = Felipe(argin);
end
