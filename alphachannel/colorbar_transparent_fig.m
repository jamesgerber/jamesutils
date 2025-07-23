function colorbar_transparent_fig(colordata,cmap,transpdata,tmap,figfilename,legendname);
% colorbar_transparent_fig


if nargin < 5
    figfilename='outputfig.png';
end

if nargin <6
    legendname='legend.png';
end




% make a figure 

NSSBase.oceancolor=[1 1 1];
NSSBase.nodatacolor=[1 1 1];
NSSBase.longlatlines='off'
NSSBase.cbarvisible='off';
NSSBase.filename='colormap_temp';
nsg(colordata,NSSBase,'cmap',cmap);

NSSBase.filename='graymap_temp';
nsg(transpdata,NSSBase,'cmap',tmap);

graytoscaledalpha('colormap_temp',figfilename,'graymap_temp');


scaledalphacolorbar(cmap,tmap,legendname);