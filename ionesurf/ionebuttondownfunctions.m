function IonEButtonDownFunctions(varargin);

if nargin==0
    help(mfilename);
    return
end

Hfig=gcbf;
InputFlag=varargin{1};
CallbackString=['Figure Zoom|Zoom To Point|Point Data'];

switch(InputFlag)
    case 'Initialize'
        position=NextButtonCoords;
        %%%[20 65 100 20]
        uicontrol('style','popupmenu','String',CallbackString,'Callback', ...
            'IonEButtonDownFunctions(''ChangeButtonBehaviorCallback'')',...
            'position',position);
        return
    case 'ChangeButtonBehaviorCallback'
        
        % case 'ChangeProjectionCallback'
        %Val will be the number corresponding to the string of the uicontrol.
        Val=get(gcbo,'Value');
        
        switch Val
            case 1
                zoom(Hfig,'on');
                
            case 2
                zoom(Hfig,'off');
                set(Hfig,'WindowButtonDownFcn',@ZoomToPointButtonDownCallback);
                
            case 3
                zoom(Hfig,'off');
                set(Hfig,'WindowButtonDownFcn',@PointSummaryButtonDownCallback);
                
            otherwise
                error(['syntax error in ' mfilename])
        end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PointSummaryButtonDownCallback   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PointSummaryButtonDownCallback(src,event)

geo0=load([iddstring '/AdminBoundary2020/gadm36_level0raster5minVer0.mat']);
geo1=load([iddstring '/AdminBoundary2020/gadm36_level1raster5minVer0.mat']);

if strcmp(get(src,'SelectionType'),'normal')
    
    UDS=get(gcbf,'UserData');
    if CheckForMappingToolbox
        cp=gcpmap;
        y=cp(1,1);
        x=cp(1,2);
    else
        cp=get(UDS.DataAxisHandle,'CurrentPoint');
        y=cp(1,2);
        x=cp(1,1);
    end
    [CountryNumbers,CountryNames,longlist,latlist]=...
        GetCountry5min(x,y);
    CountryName=CountryNames{1};
    ii=find(CountryName==',');
    if ~isempty(ii)
        CountryName=CountryName(1:(ii(1)-1));
    end
     z=UDS.Data;
     
     [ix,iy]=LatLong2RowCol(y,x,z);
     zvalue=z(ix,iy);
     disp(['ix=' int2str(ix)])
     disp(['iy=' int2str(iy)])
     disp(['vectorindex=' int2str(sub2ind(size(z),ix,iy))]);     

     
     % now GADM information
     igadm0=geo0.raster0(ix,iy);
     if igadm0==0
         gadm0name='ocean';
         gadm0='XXX';
     else
         gadm0name=geo0.namelist0{igadm0};
         gadm0=geo0.gadm0codes{igadm0};
     end
     disp(['gadm0 = ' gadm0name ' ' gadm0]);
     
     
     %%% now set text in the console
     % first delete old text
     h=findobj('Tag','IonEConsoleText');
     delete(h);
     
     %now new text
     hc=UDS.ConsoleAxisHandle;
     axes(hc)
     set(hc,'xlim',[0 1]);
     set(hc,'ylim',[0 1]);
     ht=text(0.02,9.5,['Country=' CountryName]);
     display('Point Data:');
     display(['Country = ' CountryName]);
     set(ht,'Tag','IonEConsoleText');
     ht=text(0.26,9.5,['Value = ' num2str(zvalue)]);
     display(['Value = ' num2str(zvalue)]);
     set(ht,'Tag','IonEConsoleText');
     ht=text(0.5,9.5,['Lat = ' num2str(y)]);
     display(['Lat = ' num2str(y)]);
     set(ht,'Tag','IonEConsoleText');
     ht=text(0.74,9.5,['Lon = ' num2str(x)]);
     set(ht,'Tag','IonEConsoleText');  
     display(['Lon = ' num2str(x)]);
     axes(UDS.DataAxisHandle);  %make data axis handle current
     try   
         evalin('base','pointdata;');
     catch
         assignin('base','pointdata',cell(0,4));
     end
     pdataold=evalin('base','pointdata;');
     pdatanew=cell(size(pdataold,1)+1,4);
     pdatanew(2:size(pdatanew,1),:)=pdataold;
     pdatanew(1,:)={zvalue, CountryName, y, x};
     assignin('base','pointdata',pdatanew);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ZoomToPointButtonDownCallback   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ZoomToPointButtonDownCallback(src,event)

if strcmp(get(src,'SelectionType'),'normal')
    
    UDS=get(gcbf,'UserData');
    cp=get(UDS.DataAxisHandle,'CurrentPoint');
    y1=cp(1,2);
    x1=cp(1,1);
    if CheckForMappingToolbox
        cp=gcpmap;
        y=cp(1,1);
        x=cp(1,2);
    else
        cp=get(UDS.DataAxisHandle,'CurrentPoint');
        y=cp(1,2);
        x=cp(1,1);
    end
    [CountryNumbers,CountryNames]=...
        GetCountry_halfdegree(x,y);
    CountryName=CountryNames{1};
    ii=find(CountryName==',');
    if ~isempty(ii)
        CountryName=CountryName(1:(ii(1)-1));
    end

     z=UDS.Data;
     
     [ix,iy]=LatLong2RowCol(-y,x,z);
     zvalue=z(ix,iy);
     disp(['ix=' int2str(ix)])
     disp(['iy=' int2str(iy)])
     disp(['vectorindex=' int2str(sub2ind(size(z),ix,iy))]);
     
     
     %%% now set text in the console
     % first delete old text
     h=findobj('Tag','IonEConsoleText');
     delete(h);
     
     %now new text
     hc=UDS.ConsoleAxisHandle;
     axes(hc)
     ht=text(0.02,9.5,['Country=' CountryName]);
     display('Point Data:');
     display(['Country = ' CountryName]);
     set(ht,'Tag','IonEConsoleText');
     ht=text(0.26,9.5,['Value = ' num2str(zvalue)]);
     display(['Value = ' num2str(zvalue)]);
     set(ht,'Tag','IonEConsoleText');
     ht=text(0.5,9.5,['Lat = ' num2str(y)]);
     display(['Lat = ' num2str(y)]);
     set(ht,'Tag','IonEConsoleText');
     ht=text(0.74,9.5,['Lon = ' num2str(x)]);
     set(ht,'Tag','IonEConsoleText');  
     display(['Lon = ' num2str(x)]);
     
     try   
         evalin('base','pointdata;');
     catch
         assignin('base','pointdata',cell(0,4));
     end
     pdataold=evalin('base','pointdata;');
     pdatanew=cell(size(pdataold,1)+1,4);
     pdatanew(2:size(pdatanew,1),:)=pdataold;
     pdatanew(1,:)={zvalue, CountryName, y, x};
     assignin('base','pointdata',pdatanew);
     
     LongVal=x1;
     LatVal=y1;
     % now want to zoom axes ...
     try
         DeltaLong=UDS.ZoomLongDelta;
         DeltaLat=UDS.ZoomLatDelta;
     catch
         DeltaLong=2.5;
         DeltaLat=2.5;
     end
     
     axis(UDS.DataAxisHandle,[LongVal-DeltaLong LongVal+DeltaLong LatVal-DeltaLat LatVal+DeltaLat]);

%      % now rescale caxis
%      
%     % if isvector(xx)
%          ix=find(xx>LongVal-DeltaLong & xx< LongVal+DeltaLong);
%          iy=find(yy>LatVal-DeltaLat & yy <LatVal+DeltaLat);
%      
%          lowerval=min(min(z(iy,ix)));
%          upperval=max(max(z(iy,ix)));
%      %else
%       caxis([UDS.DataAxisHandle],[lowerval upperval]);
      axes(UDS.DataAxisHandle); %make data axis handle current
end
