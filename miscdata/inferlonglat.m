function [Long,Lat,Long2,Lat2]=InferLongLat(Data)
%INFERLONGLAT constructs long and lat vectors for map
%
%  Syntax
% [Long,Lat]=InferLongLat(Data)
%
% [Long,Lat,Long2,Lat2]=InferLongLat(Data)
%
% Data can also be a 2-element num rows / num columns
%
% EXAMPLE
% [long,lat]=InferLongLat(datablank);
% [long,lat]=InferLongLat([4320 2160]);
%

if nargin==0
   disp([' assuming 5minute grid '])
   Data=datablank;
    
%    help(mfilename);
%    return
end

if numel(Data)>2

    [Nrow,Ncol,Level]=size(Data);
else
    Nrow=Data(1);
    Ncol=Data(2);
    if~isequal(Nrow,Ncol*2)
        error(['Nrows must be double Ncols'])
    end
end

%the next two lines are a lazy way to get Long to take on the
%values of the centers of the bins
tmp=linspace(-1,1,2*Nrow+1);
Long=180*tmp(2:2:end).';

tmp=linspace(-1,1,2*Ncol+1);
Lat=-90*tmp(2:2:end).';


%warning(['Have constructed Lat and Long with assumption that data' ...
%	   ' spans the globe.  It would be better to put in code that' ...
%	   ' looks to see if the dimensions are "standard" (e.g. 5' ...
%	   ' minutes) and if so use "standard" Lat/Long definitions.']);

if nargout >2
    [Lat2,Long2]=meshgrid(Lat,Long);
end