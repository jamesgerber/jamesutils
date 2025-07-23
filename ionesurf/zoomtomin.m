function ZoomToMin(varargin);
% ZOOMTOMIN - Zoom graph to minimum value.

if nargin==0
    help(mfilename);
    return
end

InputFlag=varargin{1};

switch(InputFlag)
    case 'Initialize'
        uicontrol('String','Zoom to min','Callback', ...
            'ZoomToMin(''ZoomIn'')','position',NextButtonCoords);
    case 'ZoomIn'
        % find minimum, zoom in
        
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
        
        if length(unique(z))==1
            z=get(hc(end),'CData');
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
            [minval,RowIndex,ColumnIndex]=max2d(-z);
            disp(['min value=' num2str(-minval)]);
            LongVal=xx(ColumnIndex);
            LatVal=yy(RowIndex);
        else
            ii=find(isnan(xx) | isnan(yy));
            z(ii)=max(max(z(ii)))+1;
%            xx=imresize(xx,size(z));
%            yy=imresize(yy,size(z));
            % assign minimal values here ... this
            %makes sure that we don't sneak by with a NaN
            % this is necessary because the mapping toolbox pads the x and y
            % matrices with NaNs
            
            [minval,RowIndex,ColumnIndex]=max2d(-z);
            
            disp(['min value=' num2str(-minval)]);

            
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
        
      %  axis(UDS.DataAxisHandle,[LongVal-DeltaLong LongVal+DeltaLong LatVal-DeltaLat LatVal+DeltaLat]);
      axis(UDS.DataAxisHandle,[LongVal-DeltaLong LongVal+DeltaLong LatVal-DeltaLat LatVal+DeltaLat]./UDS.ScaleToDegrees);
  
        
        %        [CountryNumber,CountryName]=GetCountry5min(LongVal*UDS.ScaleToDegrees,LatVal*UDS.ScaleToDegrees);
        [CountryNumber,CountryName]=GetCountry5min(LongVal,LatVal);
 
        disp(CountryName)
 
        ht=outputtoionefigureconsole(UDS,CountryName,-minval,LongVal,LatVal);
        
        
        
    otherwise
        error('syntax error in ZoomToMin.m')
        
end
end
