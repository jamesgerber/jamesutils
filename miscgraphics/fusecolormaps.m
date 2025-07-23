function cmap=fusecolormaps(cmap1,cmap2,glue);
% fusecolormaps - fuse two colormaps 
%
%  Syntax
%        fusecolormaps(map1,map2)
%        fusecolormaps(map1,map2,glue) where glue is a three element vector
%        which describes (in RBG) the color which will fuse the two
%        colormaps.
%    
%
%   Example
%       cmap1='greens_deep';
%       cmap2='reds_deep';
%       cmapfused=fusecolormaps(cmap1,cmap2);
%
% S=OpenNetCDF([iddstring '/Crops2000/crops/maize_5min.nc'])
% 
%   Area=S.Data(:,:,1);
%   Yield=S.Data(:,:,2);
%    NSS.Units='tons/ha';
%   fakedata=Yield-5;
%   
% NewMap=StretchColorMap(cmap1,-5,15);
%   nsgfast(fakedata,'cmap',NewMap,'caxis',[-5 15])
% NewMap=StretchColorMap(cmap2,-5,15);
%   nsgfast(fakedata,'cmap',NewMap,'caxis',[-5 15])
% NewMap=StretchColorMap(cmapfused,-5,15);
%   nsgfast(fakedata,'cmap',NewMap,'caxis',[-5 15])%
    
if nargin==0
    help(mfilename)
    return
end

if nargin<3
    glue=[1 1 1];
end

c1=finemap(cmap1,'','');
c2=finemap(cmap2,'','');
cmap=[c1(end:-1:1,:); glue; glue;glue;glue;glue; glue;glue;glue;glue; ...
    glue;glue;glue;glue; glue;glue;glue;glue; glue;glue;glue;glue; glue;...
    glue;glue; c2];
