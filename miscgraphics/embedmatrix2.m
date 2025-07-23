function [BigMatrix] = embedmatrix2(LittleMatrix,longs,lats)

% function [BigMatrix] = embedmatrix(LittleMatrix,longs,lats)
%
% this function is designed to embed a map into a blank matrix compatable
% with GLI's mapping programs (NiceSurfGeneral, etc.) for easy mapping of
% sub-global datasets
%
% LittleMatrix must be a 2-D matrix / map
%     e.g. the map you're trying to embed; it should be a smaller range
%     than the entire globe
%
% longs and lats must be vectors of the latitudes and longitudes of
% LittleMatrix
%     e.g. longs must be the length of the number of cols in LittleMatrix
%          lats must be the length of the number of rows in LittleMatrix
%
% Example: (where you want to embed a random part of the Amazon that's
%           at a 0.5 degree resolution into a global BigMatrix to then
%           pass to NSG)
%
%       % real Amazon longs and lats (CSO confirmed these for this example)
%       lats=5.7500:-0.5:-20.2500;
%       longs=-79.7500:+0.5:-45.7500;
%
%       % fake Amazon matrix (dimensions of lats and longs above)
%       LittleMatrix = ones(length(longs),length(lats));
%
%       % use embedmatrix
%       [BigMatrix] = embedmatrix(LittleMatrix,longs,lats);
%
%       % now you can easily use the mapping GLI tools!
%       nsg(BigMatrix)
%
% written by: CS O'Connell; Oct 6, 2012; UMN EEB/IonE
%


%% to do

% to prevent 0.833334 being a problem
   % longgapbig=round(longgap*10000);
   % case longgapbig==833

% there's  aproblem with embedmatrix ... roundoff error is screwing it 
% up.   i'm going to let you fix it.   try to use the function 'closeto'  
% instead of '=='

   
   
   

%% determine LittleMatrix resolution and assign BigMatrix size

longgap = abs(longs(2)-longs(1));
latgap = abs(lats(2)-lats(1));

if closeto(longgap,latgap,.001)
    switch longgap
        case longgap == 0.5
            BigMatrix = zeros(720,360);
        case longgap == 0.0833
            BigMatrix = zeros(4320,2160);
        otherwise
            % recall that a 1degree x 1degree grid is (360,180)
            % check if longgap/latgap is an integer
            tmp=round(longgap);
            if (tmp==longgap)==1
                fraction=1/longgap;
                BigMatrix = zeros(360*fraction,180*fraction);
            else
                % longgap/latgap not an integer, so must find fraction
                fraction=1/longgap; % e.g. 1/0.0833 (five minute longgap)
                fraction=round(fraction); % e.g. 12
                BigMatrix = zeros(360*fraction,180*fraction);
            end
    end
else
    error('The steps in your latitude vector are not the same as the steps in your longitude vector.')
end


%% find lats and longs of top left corner of LittleMatrix

longTL = min(longs); % furthest west
latTL = max(lats); % furthest north


%% find equivalent lats and longs in BigMatrix

% get the lats and longs of BigMatrix
[Long,Lat]=InferLongLat(BigMatrix);

[valueLong,ii]=ClosestValue(Long,longTL);
disp(['The top left point of LittleMatrix was originally longitude ' ...
    num2str(longTL) ' and has been mapped to longitude ' ...
    num2str(valueLong) '.' ])
[valueLat,jj]=ClosestValue(Lat,latTL);
disp(['The top left point of LittleMatrix was originally latitude ' ...
    num2str(latTL) ' and has been mapped to longitude ' ...
    num2str(valueLat) '.' ])

% make sure that there was a match for lats and longs
if isempty(ii)==1
    error('The first longitude in your "longs" vector does not match a longitude on the standard global matrix for your LittleMatrix resolution.')
end
if isempty(jj)==1
    error('The first latitude in your "lats" vector does not match a latitude on the standard global matrix for your LittleMatrix resolution.')
end

% as long as we could match the lats and longs, now can define the row,
% col placement of LittleMatrix
longcol = ii;
latrow = jj;


%% embed LittleMatrix in BigMatrix

sizeLM=size(LittleMatrix);

%%%%%% this next line works.... why????  aren't lat and long backwards in this????
%%%%%% don't question it.  this is working.  even though it's off from the
%%%%%% practice below.
BigMatrix(longcol:(longcol+sizeLM(1)-1),latrow:(latrow+sizeLM(2)-1)) = LittleMatrix;

% example for how I got the above code
% y = zeros(8)
% x = rand(2,3)
% sizex=size(x)
% y(latrow:(latrow+sizex(1)-1),longcol:(longcol+sizex(2)-1)) = x

end



