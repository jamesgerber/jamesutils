function varargout=PropagateCaxis(varargin);
% PROPAGATELIMITS - propagate limits from this figure to all "IonEFigures"
%
%  if 'Import' syntax is used, will return handle to the title.
if nargin==0
    help(mfilename);
    return
end

InputFlag=varargin{1};

switch(InputFlag)
    case 'Initialize'
        uicontrol('String','Export Color Axis','Callback', ...
            'PropagateCaxis(''Export'')','position',NextButtonCoords);	

 case 'Export'
  %%% get the limits of this axis  
  hax=get(gcbf,'CurrentAxes');
  Clim=get(hax,'CLim')
  Ylim=get(hax,'YLim')
  
  
  hall=allchild(0); % all handles
  for j=1:length(hall)
    if isequal(get(hall(j),'Tag'),'IonEFigure');
      % we have an "IonEFigure". Resize.
      PropagateCaxis('Import',hall(j),Clim,Ylim);
    end
  end
  
    case 'Import';
        ThisFig =varargin{2};
        ThisCLim=varargin{3};
        ThisYLim=varargin{4};
        figure(ThisFig) % it might be cleaner to search for the axes.
        % Alternatively, search for the tags on the axes themselves.
        set(gca,'CLim',ThisCLim);
      %  set(gca,'YLim',ThisYLim);
% %         fud=get(ThisFig,'userdata');
% %         
% %       %  y0=ThisYLim(2)
% %       %  dely=diff(ThisYLim);
% %       %  x0=mean(ThisXLim);
% %         if isfield(fud,'titlehandle')
% %             delete(fud.titlehandle);
% %         end
% %         ht=text(x0,y0+dely*0.05,fud.titlestring);
% %         set(ht,'FontSize',14)
% %         set(ht,'HorizontalAlignment','center');
% %         
% %         set(ht,'FontWeight','Bold');
% %         set(ht,'tag','NSGTitleTag');
% %         fud.titlehandle=ht;
% %         set(ThisFig,'userdata',fud);
% %         UserInterpPreference=callpersonalpreferences('texinterpreter');
% %         
% %         set(ht,'interp',UserInterpPreference);
% %         
% %         varargout{1}=ht;
    otherwise
        error('syntax error in PropagateLimits.m');
        
end

