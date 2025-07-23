
C=OpenNetCDF('/Library/IonE/data//Crops2000/Cropland2000_5min.nc');
P=OpenNetCDF('/Library/IonE/data//Crops2000/Pasture2000_5min.nc');

personalpreferences('printingres' , '-r600' ) 

 clear NSSBase
NSSBase.coloraxis = [.99];
%NSSBase.resolution='-r200';
NSSBase.colorbarpercent='on';
NSSBase.caxis=[0 100];
NSSBase.plotstates='off'
NSSBase.oceancolor=[1 1 1];
NSSBase.nodatacolor=[1 1 1];
NSSBase.longlatlines='off'
%NSSBase.projection='mollweid';

NSS=NSSBase;
NSS.Units = 'percent land covered by crops ';
NSS.TitleString = [' Cropland and pasture extent in 2000 '];
NSS.FileName ='croplandextent_2000';
%%%NSS.cmap ='jfclover';
NSS.cmap='greens_deep';
%c=finemap('colorbrewercontinuous','','');
%NSS.cmap=c(end/2:-1:1,:);
NiceSurfGeneral(C.Data*100, NSS);
MakeWhiteOutsideGraph('croplandextent_2000');
NiceSurfGeneral(C.Data*100, NSS,'filename','croplandgray','cmap','revgray');
MakeWhiteOutsideGraph('croplandgray');

NSS=NSSBase;

NSS.Units = 'percent land covered by pasture ';
NSS.TitleString = [' Pasture extent in 2000 '];
NSS.FileName ='pastureextent_2000';
%%%NSS.cmap ='jfcayenne';
NSS.cmap='oranges_deep';
c=finemap(NSS.cmap,'','');
N=length(c);
NSS.cmap=c(round(N/2):-1:1,:);
NiceSurfGeneral(P.Data*100, NSS);
MakeWhiteOutsideGraph('pastureextent_2000');
NiceSurfGeneral(P.Data*100, NSS,'filename','pasturegray','cmap','revgray');
MakeWhiteOutsideGraph('pasturegray');

MixDualFigures croplandextent_2000_whiteout croplandgray_whiteout pastureextent_2000_whiteout pasturegray_whiteout tmp



% make a topography figure
S=OpenNetCDF([iddstring '/Climate/CRU_5min_elv.nc']);
elev=S.Data;
elev(elev<-9000)=NaN;
elev=elev+min(min(elev));
elev=elev/max(max(elev));
clear NSS
NSS=NSSBase;
NSS.title='';
%NSS.Resolution='-600';
NSS.cmap='revgray';
NSS.caxis=[0 2];
NSS.filename='topography';j
NSS.cbarvisible='off';
OSS=nsg(elev,NSS);
%MakeGlobalOverlay(OSS.Data,gray,OSS.coloraxis,'topography',1.0,4000,2000)






% 
% 
% 
% 
% 
% 
% 
% 
% 
%  clear NSS
% 
% NSS.Units = 'percent land cover';
% NSS.TitleString = [' Cropland extent in 2000 '];
% NSS.FileName ='croplandextent_2000';
% NSS.cmap ='jfclover';
% NSS.categorical = 'off';
% NSS.coloraxis = [.99];
% NSS.resolution='-r1200';
% 
% NSS.colorbarpercent='on';
% NSS.caxis=[0 100]
% 
% NiceSurfGeneral(C.Data*100, NSS);
% 
% 
% NSS.Units = 'percent land cover';
% NSS.TitleString = [' Pasture extent in 2000 '];
% NSS.FileName ='pastureextent_2000';
% NSS.cmap ='jfcayenne';
% NSS.categorical = 'off';
% NSS.coloraxis = [.99];
% NSS.colorbarpercent='on';
% NSS.colorbarpercent='on';
% NSS.caxis=[0 100]
% 
% %[LogicalInclude,filteredmap]=AreaFilter(totalarea,...
% %    cerealya,0.95);
% 
% NiceSurfGeneral(P.Data*100, NSS);
% 
% 
% 
% 
% 
% 
