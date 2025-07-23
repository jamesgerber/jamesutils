function [long5mincenter,lat5mincenter,maxEVI5min]=aggregate_to_5min(long2000,lat2000,maxEVI2000,Nrow);
% aggregate_to_5min - aggregate a high-resolution raster to 5 mins
%
%  Syntax   [long5min,lat5min,raster5min]=aggregate_to_5min(longhires,lathires,hiresraster);
%
%   this finds the outer corner of the 5 minute grids that are encompassed
%   in the raster and for each 5 minute pixel takes the mean values of all
%   of the high-resolution grid cells whose centers are in that pixel.
%
%   optional
%
%           [longlowres,latlowres,rasterlowres]=aggregate_to_5min(longhires,lathires,hiresraster,Nrows);



% note this is a modification of the code inside inferlonglat

if nargin<4
    Nrow=4320;
end

Ncol=Nrow/2;

tmp=linspace(-1,1,2*Nrow+1);
x=180*tmp(1:2:end).';

tmp=linspace(-1,1,2*Ncol+1);
y=-90*tmp(1:2:end).';
% what are long,lat limits at 5 min that span the higher-resolution?

iistart= min( find(x>long2000(1) ));
iiend= max( find(x<long2000(end) )); % should be 'end'

jjstart= min( find(y<lat2000(1) ));
jjend= max( find(y>lat2000(end) )); % should be 'end'

long5min=x(iistart:iiend);
lat5min=y(jjstart:jjend);


lml=landmasklogical;
if Nrow~=4320
    lml=aggregate_rate(lml,4320/Nrow);
end

ii5min=(iistart:iiend);  % index into landmasklogical
jj5min=jjstart:jjend;


numel(long5min)-1

legacy=0;
if legacy==1
    % horrible version where every pixel is an average.  will take a long
    %time - but easy to debug and test
    tic
    for i=1:numel(long5min)-1;
        i
        
        ii=find(long2000 > long5min(i) & long2000 < long5min(i+1));
        
        
        for j=1:numel(lat5min)-1;
            jj=find(lat2000 < lat5min(j) & lat2000 > lat5min(j+1));
            
            avgvalue=mean(mean(maxEVI2000(ii,jj)));
            
            maxEVI5min(i,j)=avgvalue;
        end
    end
    toc
else
    % exclude points not on landmask
        tic
    for i=1:numel(long5min)-1;
  %      i
        
        ii=find(long2000 > long5min(i) & long2000 < long5min(i+1));
        
        
        for j=1:numel(lat5min)-1;
            
            if  lml(ii5min(i),jj5min(j))==0;
                
                maxEVI5min(i,j)=nan;
            else
            jj=find(lat2000 < lat5min(j) & lat2000 > lat5min(j+1));
            
            avgvalue=mean(mean(maxEVI2000(ii,jj)));
            
            maxEVI5min(i,j)=avgvalue;
            end
        end
    end
    toc
    % better version where collapse a "thick" column of values into a 1-D
    % column so averages over the rows are much faster.
%  doesn't seem to be much faster ... at least not for small N test cases
%     tic
%     for i=1:numel(long5min)-1;
%         i
%         
%         ii=find(long2000 > long5min(i) & long2000 < long5min(i+1));
%         
%         avgvalcolumn=mean(maxEVI2000(ii,:));
%         
%         for j=1:numel(lat5min)-1;
%             jj=find(lat2000 < lat5min(j) & lat2000 > lat5min(j+1));
%             
%             % avgvalue=mean(mean(maxEVI2000(ii,jj)));
%             avgvalue=mean(avgvalcolumn(jj));
%             maxEVI5min(i,j)=avgvalue;
%         end
%     end
%     toc
    
    
end
long5mincenter=(long5min(1:end-1)+long5min(2:end))/2;
lat5mincenter=(lat5min(1:end-1)+lat5min(2:end))/2;

% slightly less embarrassing code would average over all ii, and then the
% loop over j would be much faster.










