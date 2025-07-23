function graytoscaledalpha(OldFileName,NewFileName,ScaleFileName);
% graytoscaledalpha - render a figure proportionally transparent 
%
%  Syntax
%
%  SYNTAX
%   graytoscaledalpha(OldFileName,NewFileName,ScaleFileName) - where
%   OldFileName and ScaleFileName refer to images of the same size, make
%   all pixels in OldFileName transparent relative to the brightness of 
%   the pixels in the same locations in ScaleFileName.
%
%   If ScaleFileName is unspecified, use OldFileName.  Save the resulting
%   image to NewFileName.  If NewFileName is unspecified, use
%   <OldFileName>_alpha.png.
%

if nargin==1
    NewFileName=strrep(OldFileName,'.png','_alpha.png');
end
if nargin<3
    ScaleFileName=OldFileName;
end
OldFileName=fixextension(OldFileName,'.png');
ScaleFileName=fixextension(ScaleFileName,'.png');

plotimage=imread(OldFileName);

scaleimage=imread(ScaleFileName);

a=plotimage;

%%ii=(a(:,:,1)>=254 & a(:,:,2) >=254 & a(:,:,3)>=254);



Alpha=(double(255-scaleimage(:,:,1))/255);

imwrite(plotimage,NewFileName,'png','Alpha',double(Alpha));%,'Background',ones(size(Alpha)));

return
%% here is example code

% paste it in ... the "return" statement above keeps this code from
% executing by itself.

% Then put the two _alpha.png files into keynote to see the effect


C=OpenNetCDF([iddstring '/Crops2000/Cropland2000_5min.nc']);
P=OpenNetCDF([iddstring '/Crops2000/Pasture2000_5min.nc']);

clear NSSBase
NSSBase.coloraxis = [.99];
NSSBase.resolution='-r600';
NSSBase.colorbarpercent='on';
NSSBase.caxis=[0 100];
NSSBase.plotstates='off'
NSSBase.oceancolor=[255 255 255]/256;
NSSBase.nodatacolor=[255 255 255]/256;
NSSBase.longlatlines='off'

NSS=NSSBase;
NSS.Units = 'percent land cover';
NSS.TitleString = [' Cropland extent in 2000 '];
NSS.FileName ='croplandextent_2000';
NSS.cmap ='dark_greens_deep';

%% make one with color
OSS=NiceSurfGeneral(C.Data*100, NSS);
MakeGlobalOverlay(OSS.ProcessedMapData,OSS.cmap_final,OSS.coloraxis,'cropland',1.0,4320,2160);

%% make one that's gray
OSS=NiceSurfGeneral(C.Data*100, NSS,'filename','croplandgray','cmap','revgray');
MakeGlobalOverlay(OSS.ProcessedMapData,OSS.cmap_final,OSS.coloraxis,'cropland_gray',1.0,4320,2160);

%% use the gray one to scale the transparency of the colorone
graytoscaledalpha('cropland.png','cropland_alpha.png','cropland_gray.png')


%% same thing, now with Pasture

NSS.Units = 'percent land cover';
NSS.TitleString = [' Pasture extent in 2000 '];
NSS.FileName ='pastureextent_2000';
NSS.cmap ='dark_oranges_deep';

%% make one with color
OSS=NiceSurfGeneral(P.Data*100, NSS);
MakeGlobalOverlay(OSS.ProcessedMapData,OSS.cmap_final,OSS.coloraxis,'pasture',1.0,4320,2160);

%% make one that's gray
OSS=NiceSurfGeneral(P.Data*100, NSS,'filename','pasturegray','cmap','revgray');
MakeGlobalOverlay(OSS.ProcessedMapData,OSS.cmap_final,OSS.coloraxis,'pasture_gray',1.0,4320,2160);

%% use the gray one to scale the transparency of the colorone
graytoscaledalpha('pasture.png','pasture_alpha.png','pasture_gray.png')

% % % 
% % % %MakeSMMOverlay(OSS,'pasture_layer')
% % % 
% % % OSS=NiceSurfGeneral(P.Data*100, NSS,'filename','pasturegray','cmap','revgray');
% % % 
% % % MakeSMMOverlay(OSS,'cropland_layer_gray')

NSS=NSSBase;

NSS.Units = 'percent land cover';
NSS.TitleString = [' Pasture extent in 2000 '];
NSS.FileName ='pastureextent_2000';
NSS.cmap ='dark_oranges_deep';
OSS=NiceSurfGeneral(P.Data*100, NSS);
MakeSMMOverlay(OSS,'pasture_layer')
OSS=NiceSurfGeneral(P.Data*100, NSS,'filename','pasturegray','cmap','revgray');
MakeSMMOverlay(OSS,'pasture_layer_gray')
