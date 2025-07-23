function DataEditSurf(Data)

zoom on

[Long,Lat]=InferLongLat(Data);

RedLong=Long;
RedLat=Lat;
RedData=Data;


%% invert data to conform with matlab standard

RedLat=RedLat(end:-1:1);
RedData=RedData(:,end:-1:1);

RedData=RedData+1.0;

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
caxis([1 max2d(RedData)+1]);
UserDataStructure.Fig=hfig;
UserDataStructure.DataAxisHandle=gca;
UserDataStructure.Lat=RedLat;
UserDataStructure.Long=RedLong;
UserDataStructure.Data=RedData;
UserDataStructure.CellSize=NumPointsPerDegree;

colorbar('hide');
shading flat

set(hfig,'UserData',UserDataStructure);

modifyPoint('Initialize');

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