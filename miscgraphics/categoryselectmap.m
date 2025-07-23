function CategorySelectMap(Data,cmap,backdata,bmap,selectcolor);
% CATEGORYSELECTMAP - interactive category selection tool
%
%   Syntax:
%  CategorySelectMap(Data,cmap,backdata,bmap);
%
% Creates an interactive figure which lets the user click on a spot on the
% map to highlight it and all other areas with the same value. If provided,
% it will display another data set behind the primary one. (By default, a
% medium-quality composite satellite image of earth is used.) This data set
% can be an indexed image at 2160x4320 pix. To make an image display
% properly on a map projection, use the following:
% CategorySelectMap(Data,cmap,flipud(rot90(backdata)),bmap)
% Higher-resolution colormaps will look much nicer but may also seriously
% impact runtime and space-efficiency.
%
%
% Example
%
%  load([iddstring 'YieldGap/AreaFiltered/' ...
%     'YieldGap_Maize_MaxYieldPct_95_AreaFilteredClimateSpace_10x10_prec.mat']);
%  data=OS.ClimateMask;
%
%  load([iddstring 'YieldGap/AreaFiltered_Soil/' ...
%     'YieldGap_Maize_MaxYieldPct_95_AreaFilteredClimateSpaceWithSoil_5x5_prec.mat']);
%  data=OS.ClimateMask;
%  data=data(1:2:end,1:2:end);
% CategorySelectMap(data)
%
%
%  AMT
%  July 2010

if nargin==0
    help(mfilename)
    return
end

if (nargin==1)
    cmap=jet(500);
end

if (nargin<4)
    bmap=jet(500);
end

if (nargin<5)
    selectcolor=[.95,.95,0];
end

Data=double(Data);
bmax=-9;

if (nargin<3)
    load worldindexed
    bmap=immap;
    backdata=EasyInterp2(flipud(rot90(im)),size(Data,1),size(Data,2));
    bmax=length(immap)+1;
end

if bmax==-9
    bmax=max2d(backdata)+1;
end

for i=length(cmap)+1:-1:2
    cmap(i,:)=cmap(i-1,:);
end
cmap(1,:)=.7;
cmap(length(cmap)+1,:)=.7;

for i=length(bmap)+1:-1:2
    bmap(i,:)=bmap(i-1,:);
end
bmap(1,:)=selectcolor;
bmap(length(bmap)+1,:)=selectcolor;

[Long,Lat]=InferLongLat(Data);
Units='';

RedLong=Long;
RedLat=Lat;
RedData=Data;


%% invert data to conform with matlab standard

RedLat=RedLat(end:-1:1);
RedData=RedData(:,end:-1:1);
backdata=backdata(:,end:-1:1);

RedData=RedData+1.0;
backdata=backdata+1.0;

hfig=figure;

% calculate place to put figure
if hfig<30
    XStart=100+30*hfig;
    YStart=800-20*hfig;
else
    XStart=100;
    YStart=800;
end


set(gcf,'renderer','zbuffer');

pos=get(hfig,'position');
newpos=[XStart YStart pos(3)*1.5 pos(4)*(0.9)];
%set(hfig,'position',[XStart YStart 842  440]);
set(hfig,'position',newpos);
%mps=get(0,'MonitorPositions');

%pos=pos.*[1 1 1.5 .9];
%set(hfig,'Position',pos);
set(hfig,'Tag','IonEFigure');

% Establish a UserDataStructure

  hm=axesm('robinson')
  NumPointsPerDegree=12*numel(RedLat)/2160;
  R=[NumPointsPerDegree,90,-180]
  h=meshm(double(RedData.'),R);
  shading flat;
colormap(gca,cmap);
caxis([1 max2d(RedData)+1]);
max2d(RedData)
UserDataStructure.Fig=hfig;
UserDataStructure.CMap=cmap;
UserDataStructure.BMax=bmax;
UserDataStructure.DataAxisHandle=gca;
UserDataStructure.Lat=RedLat;
UserDataStructure.Long=RedLong;
UserDataStructure.Data=RedData;
UserDataStructure.CellSize=NumPointsPerDegree;

colorbar('hide');
shading flat

UserDataStructure.Back=backdata;
UserDataStructure.BMap=bmap;
set(hfig,'UserData',UserDataStructure);

selectCategory('Initialize');
AddStatesCallback('Initialize');
zoomButtons('Initialize');

clear NextButtonCoords
position=NextButtonCoords;
position(4)=100;
ConsoleAxisHandle=axes('units','pixels','Position',position);
set(ConsoleAxisHandle,'units','normalized');
set(ConsoleAxisHandle,'visible','off');

vis=get(UserDataStructure.DataAxisHandle,'visible');
set(UserDataStructure.DataAxisHandle,'visible',vis);
axes(UserDataStructure.DataAxisHandle);


end

function [Long,Lat]=InferLongLat(Data)

if nargin==0
    help(mfilename);
    return
end

  [Nrow,Ncol,Level]=size(Data);

  tmp=linspace(-1,1,2*Nrow+1);
  Long=180*tmp(2:2:end).';
  
  tmp=linspace(-1,1,2*Ncol+1);
  Lat=-90*tmp(2:2:end).';
end