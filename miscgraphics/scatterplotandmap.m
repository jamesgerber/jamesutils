function [hfig,OS]=scatterplotandmap(xmap,ymap,scatterindex,differentialindex,NSS);
% scatterplotandmap - make a color-coded scatter plot and a map.
%
%  SYNTAX
%          scatterplotandmap(xmap,ymap,scatterindex,colorcodingrule);
%
%      colorcoding rules include 'states' or 'slope'
%      you can also replace colorcodingrule with your own index.  This has
%      to be a full-sized map with integer values corresponding to how you
%      want to color code the map / scatterplot
% example:
%
% kk=countrycodetooutline('BRA');
% tempdata=getcropdata('maize');
% xmap=tempdata.Data(:,:,1);
% ymap=tempdata.Data(:,:,2);
% scatterindex=kk & xmap < 9e9 & ymap <9e9;
% [hfig,OS]=scatterplotandmap(xmap,ymap,scatterindex,'states');
% figure(hfig)
% grid on
% xlabel(' area ')
% ylabel(' yield ');

%
%scatterplotandmap(xmap,ymap,scatterindex,'slope',NSS);
%
%  

cmap='jet';

Ncolors=16;

if nargin==3
    if islogical(scatterindex)
        % scatterindex is a logical, but user hasn't specified how to chop up
        % the indices for plotting.  So construct differentialindex into
        % Ncolors different
        differentialindex=datablank;
        ii=find(scatterindex);
        
        integerlist=floor(linspace(1,Ncolors-1/1000,length(ii)));
        
        differentialindex(ii)=integerlist;
        
    else
        error('need to fix this')
    end
end

if nargin==4
    if ischar(differentialindex)
        switch differentialindex
            case 'slope'
                % make a histogram of different slope values, color code
                % accordingly, equally spaced by slope
                % first, normalize so that if units are crazy everything
                % won't get stuck all in one bin.
                ymapnorm=ymap./mean(abs(ymap(scatterindex)));
                xmapnorm=xmap./mean(abs(xmap(scatterindex))); 
                
                slopevals=atan(ymapnorm(scatterindex)./xmapnorm(scatterindex));
                slopevals(isnan(slopevals))=pi/2;  % because atan barfs for infinite slope
                [N,edges,bin] = histcounts(slopevals,Ncolors);
                
                differentialindex=datablank;
                kk=find(scatterindex);
                
     
                for j=1:length(N)
                    
                    ii=find( slopevals >=edges(j) & slopevals< edges(j+1));
                    differentialindex(kk(ii))=j;
                end
                    
            case {'geo','geography','map','state','states'}
                load([iddstring 'AdminBoundary2010/Raster_NetCDF/2_States_5min/ncmat/glctry.mat'])
                differentialindex=datablank;
                differentialindex(scatterindex)=DS.Data(scatterindex);
                
                ilist=unique(differentialindex);
                
                for j=1:length(ilist)-1
                    differentialindex(differentialindex==ilist(j+1))=j;
                end
                
                Ncolors=max(differentialindex(:));
                
            case 'quadrant'
                % make a histogram of different quadrants, color code
                % accordingly
                disp(['haven''t written this code yet']);

                
            otherwise
                error(['differentialindex = ' differentialindex '.  not recognized']);
        end
    end
end

% construct a matrix with integers corresponding to the scatter plots to be
% carried out.  note that there are a few ways to go about this.


scatterintegerlist=unique(differentialindex(scatterindex));
scatterintegerlist=1:Ncolors;

%%

hfig=figure
colorarray=finemap(cmap,'','');
colorindices=round(linspace(1,size(colorarray,1),Ncolors));

for j=1:Ncolors   % don't start at 1st index - zero
    ColorVector{j}=colorarray(colorindices(j),[1 2 3]);
    ii=differentialindex==scatterintegerlist(j);
    length(find(ii))
    scatter(xmap(ii),ymap(ii),[],ColorVector{j});
    hold on
end


OS=nsg(differentialindex,'categorical','on','cmap',ColorVector,...
    'categoryranges',1:Ncolors,'separatecatlegend','yes')

