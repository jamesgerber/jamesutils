function [wtmeanmap] = weightmeanmap(mapsarray, monthslist)

% function [wtmeanmap] = weightmeanmap(mapsarray, monthslist)
%
% this function is designed to get the weighted mean of monthly climate
% maps where the weights are associated with the number of days in the
% month
%
% mapsarray must be a 3-D matrix in the form of:
%     [:,:,12]
%     e.g. the maps you're trying to weighted average for each of the 12
%     months of the year
%
% monthslist can be in the form of either:
%     vector such that ii = [6,7,8];
%     OR
%     string such that choices are 'winter','win','DJF'
%                                  'spring', 'spr','MAM'
%                                  'summer', 'sum','JJA'
%                                  'autumn', 'aut', 'fall', 'fal','SON'
%
% Example: (where you want the weighted mean of global winter temps)
% 
%       % load WorldClim avg temp maps
%       DS = OpenNetCDF([iddstring 'Climate/WorldClim_5min_tmean.nc']);
%       
%       % WorldClim is a 4-D matrix (lat, long, levels, data); convert to the
%       % 3-D format that weightmeanmap wants
%       mapsarray=zeros(4320,2160,12);
%       for j=1:12
%           mapsarray(:,:,j)=DS.Data(:,:,:,j);
%       end
%       mapsarray(mapsarray<-9000) = NaN; % -9999 used for missing vals in WorldClim, so take these out
%       
%       % use weightmeanmap
%       % exmaple with characters
%       [wtmeanmap] = weightmeanmap(mapsarray, 'winter');
%       % exmaple with vector
%       [wtmeanmap] = weightmeanmap(mapsarray, [6,7,8]);
% 
% written by: CS O'Connell; Oct 1, 2012; UMN EEB/IonE
%

% time weights (whole year)
timeweights = [ 31 28 31 30 31 30 31 31 30 31 30 31 ];

% define ii
S = class(monthslist);
switch S
    case {'char'}
        switch monthslist
            case {'winter','win','DJF'}
                ii = [12,1,2];
            case {'spring', 'spr','MAM'}
                ii = [3,4,5];
            case {'summer', 'sum','JJA'}
                ii = [6,7,8];
            case {'autumn', 'aut', 'fall', 'fal','SON'}
                ii = [9,10,11];
            otherwise
                error([ monthslist 'was not a recognized string.'])
        end
    case {'single', 'double'}
        if min(size(monthslist))==1
            ii = monthslist;
        else
            error([ monthslist 'was not the right size.'])
        end
    otherwise
        error([ 'monthslist was not the right type of variable; must be a string or vector.'])
end

% define time weights (for the months in this analysis)
monthswt = timeweights(ii);

% get matrices we're weighting
for j=1:length(ii)
    eval([ 'map' num2str(j) ' = mapsarray(:,:,ii(j));' ])
end

% let's do the math
wtsum=zeros(size(map1));
for j=1:length(ii)
    eval([ 'map = map' num2str(j) ';' ])
    tmp = timeweights(ii(j))*map;
    wtsum = wtsum + tmp;
end
wtmeanmap = wtsum ./ sum(timeweights(ii));

end

