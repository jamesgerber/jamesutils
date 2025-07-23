function AddCoasts(LineWidth,HFig);
%  ADDCOASTS - add coasts
%
%  AddCoasts(0.1)  will add some very thin lines
%
%  AddCoasts(N) where N is an integer will add lines of default thickness
%  (0.5) to figure N.   [This was added for backwards compatibility]
%
%  See Also  AddStates
if nargin==0
  HFig=gcf;
  LineWidth=0.5;
end

if nargin==1
    if LineWidth==round(LineWidth) 
        % this is a figure handle
        HFig=LineWidth;
        LineWidth=0.5;
    else
        HFig=gcf;
    end
end

hax=gca;

SystemGlobals

try
    
    if LineWidth <0.5
        load(ADMINBOUNDARY_VECTORMAP_HIRES)
    else
        load(ADMINBOUNDARY_VECTORMAP)
    end
catch  
        disp(['did not find system vectormap'])
        disp(['loading default matlab coasts'])
    load coast
end

holdstatus=ishold;
hold on

%try
%    CanMap=CheckForMappingToolbox;
%catch
%    disp(['problem with Mapping Toolbox check in ' mfilename]);
%    CanMap=0;
%end

if ~ismap(gca)
    hp=plot(long,lat,'k');
    set(hp,'linewidth',LineWidth);
else  
    hp=plotm(lat,long,'k');
    set(hp,'linewidth',LineWidth);
end

if holdstatus==0
  hold off
end