function ZoomToContinent(varargin);
% ZOOMTOMAX - Zoom graph to maximum value.
if nargin==0
    help(mfilename);
    return
end

InputFlag=varargin{1};

switch(InputFlag)
    case 'Initialize'
        uicontrol('style','popupmenu','String','pick a continent|North America|Europe|Asia|Africa|South America|Australia|World','Callback', ...
            'ZoomToContinent(''ZoomIn'')','position',NextButtonCoords);	

    case 'ZoomIn'
 
        % get scaling factor
        try
            CanMap=CheckForMappingToolbox;
        catch
            disp(['problem with Mapping Toolbox check in ' mfilename]);
            CanMap=0;
        end
        
        if (length(varargin)==2)
            Val=varargin{2};
        else
        % make user choose continent, zoom in       
            Val=get(gcbo,'Value');  %Val will be the number
        end                    %corresponding to the string of the uicontrol
%      switch Val
%       
%       case 1 %User chickened out
%        
%       case 2  %North America
%        alims=[-130 -70 10 65];
%       case 3 %Europe
%        alims=[-20 45 35 75];
%       case 4 % Asia
%        alims=[20 140 5 70];       
%       case 5 % Africa
%        alims=[-20 50 -35 35];
%       case 6 %South America
%        alims=[-110 -30 -60 25];
%       case 7 %Australia
%        alims=[90 180 -50 20];
%              case 8 %Australia
%        alims=[-180 180 -90 90];
%      end

     switch Val
      
      case 1 %User chickened out
       
      case 2  %North America
       alims=[-175 -08 05 90];
      case 3 %Europe
       alims=[-33 50 30 75];
      case 4 % Asia
       alims=[20 180 0 85];       
      case 5 % Africa
       alims=[-20 55 -40 40];
      case 6 %South America
       alims=[-90 -30 -60 17];
      case 7 %Australia
       alims=[90 180 -50 20];
             case 8 %World
       alims=[-180 180 -90 90];
     end
     


     UD=get(gcf,'UserData');
     UD
     if (UD.QuickVersion==1)
     UD.QuickVersion=0;
     varg=UD.Inputs;
     tmp='NiceSurfGeneral(varg{1}';
     for i=1:length(varg)
        if strcmpi(varg{i},'plotarea')
            varg{i+1}='';
        end
        if (i>1)
            tmp=[tmp ',varg{' num2str(i) '}'];
        end
     end
     tmp=[tmp ');'];
     close all;
     eval(tmp);
     zoomtocontinent('ZoomIn',Val);
     return
     else
     if CanMap==1
         setm(UD.DataAxisHandle,'maplonlimit',[alims(1) alims(2)]);
         setm(UD.DataAxisHandle,'maplatlimit',[alims(3) alims(4)]);
     else
         axis(UD.DataAxisHandle,alims);
     end
     end
     
     
	
	
    otherwise
        error('syntax error in ZoomToContinent.m')
        
end

