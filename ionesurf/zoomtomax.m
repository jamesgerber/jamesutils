function ZoomToMax(varargin);
% ZOOMTOMAX - Zoom graph to maximum value.
%
%  syntax:
% 
%   ZoomToMax('Initialize')
%   ZoomToMax('ZoomIn')
%   ZoomToMax('ZoomOut')

if nargin==0
    help(mfilename);
    return
end

InputFlag=varargin{1};

switch(InputFlag)
    case 'Initialize'
        uicontrol('String','Zoom to max','Callback', ...
            'ZoomToMax(''ZoomIn'')','position',NextButtonCoords);
        uicontrol('String','Zoom Out','Callback', ...
            'ZoomToMax(''ZoomOut'');','position',NextButtonCoords);
        
    case 'ZoomIn'
        % find maximum, zoom in       
        
        UDS=get(gcbf,'UserData');
        ha=UDS.DataAxisHandle;
        Xlim=get(ha,'XLim');
        Ylim=get(ha,'YLim');
        hc=get(ha,'Child');
        
        if length(hc)>1
            a=get(hc,'Type');
            ii=strmatch('surface',a);
            if length(ii)==1
                hc=hc(ii);
            else
                warning(['multiple surfaces found in ' mfilename ])
                disp(['pathetic and sad:  just taking the first one'])
                hc=hc(ii(1))
            end
        end
        
        
        xx=get(hc,'XData');
        yy=get(hc,'YData');
        z=get(hc,'ZData');
        
        if iscell(z)
            z=z{end};
            xx=xx{end};
            yy=yy{end};
        end
        % little bit of code to handle z being all zeros (if mapping
        % toolbox was used)
        
%        if length(unique(z))==1
        if length(unique(z(isfinite(z))))==1
            %z=get(hc(end),'CData');
            % switch to standard matlab convention
            z=get(hc(end),'CData')';
        end
 
        % if this was made with nicesurf or nicesurfgeneral, then need to
        % take away the values that were put there to allow for color
        % coding.  
        % This is the case if the UDS fields NiceSurfUpperCutoff and
        % NiceSurfLowerCutoff exist.
        
        if isfield(UDS,'NiceSurfLowerCutoff')
            % made with NiceSurfGeneral
            z(z<UDS.NiceSurfLowerCutoff)= mean([UDS.NiceSurfLowerCutoff UDS.NiceSurfUpperCutoff]);
            z(z>UDS.NiceSurfUpperCutoff)= mean([UDS.NiceSurfLowerCutoff UDS.NiceSurfUpperCutoff]);
        end

        
        if isvector(xx)==1
            [minval,RowIndex,ColumnIndex]=max2d(z);
            LongVal=xx(ColumnIndex);
            LatVal=yy(RowIndex);
        else
            ii=find(isnan(xx) | isnan(yy));
            z(ii)=max(max(z(ii)))+1;
%            xx=imresize(xx,size(z));
 %           yy=imresize(yy,size(z));
            % assign maximal values here ... this
            %makes sure that we don't sneak by with a NaN
            % this is necessary because the mapping toolbox pads the x and y
            % matrices with NaNs
         %   [minval,RowIndex,ColumnIndex]=max2d(z);
            [minval,ColumnIndex,RowIndex]=max2d(z);
            %   LongVal=xx(RowIndex,ColumnIndex);
            %   LatVal=yy(RowIndex,ColumnIndex);
            LongVal=UDS.Long(ColumnIndex);
            LatVal=UDS.Lat(RowIndex);

        end
        
        %% need to find out how much user wants us to zoom by.  It's
        %% encoded in the userdatastructure in the figure window.
     %   if (UDS.MapToolboxFig==1)
     %       UDS=get(gcbf,'UserData');
     %       DeltaLong=.05;
     %       DeltaLat=.025;
     %   else
            DeltaLong=10.0;
            DeltaLat=5.5;
     %   end
     adhocfactor=(180-abs(LongVal))/180;  % 1 to 0
     adhocfactor=(adhocfactor*0.5)+.5;  
     % scaling because there is a strange relationship between how I set
     % the longitude and what gets plotted (or maybe ScaleToDegrees is just
     % off and I only notice for longitude)    
     
     % adhocfactor should scale from 1 with LongVal=0 to 0.5 at LongVal=180
        
      %  axis(UDS.DataAxisHandle,[LongVal-DeltaLong LongVal+DeltaLong LatVal-DeltaLat LatVal+DeltaLat]);
      axis(UDS.DataAxisHandle,[LongVal*adhocfactor-DeltaLong LongVal*adhocfactor+DeltaLong LatVal-DeltaLat LatVal+DeltaLat]./UDS.ScaleToDegrees);
  
        
        %        [CountryNumber,CountryName]=GetCountry5min(LongVal*UDS.ScaleToDegrees,LatVal*UDS.ScaleToDegrees);
        [CountryNumber,CountryName]=GetCountry5min(LongVal,LatVal);
 
        disp(CountryName)
 
        ht=outputtoionefigureconsole(UDS,CountryName,minval,LongVal,LatVal);
        
        
       
    case 'ZoomOut'
        
        try
            CanMap=CheckForMappingToolbox;
        catch
            disp(['problem with Mapping Toolbox check in ' mfilename]);
            CanMap=0;
        end
        
        UDS=get(gcbf,'UserData');
        ha=UDS.DataAxisHandle;
        
        axes(ha);
        if CanMap==0
            axis([-180 180 -90 90]);
        else
            axis 'auto xy'
        end
    otherwise
        error('syntax error in ZoomToMax.m')
        
end
end