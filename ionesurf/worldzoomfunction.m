function varargout=WorldZoomFunction(newXLim,newYLim)
%WORLDZOOM   Show zoom location on a map of the world.
%
% Syntax:


switch nargin
    case 0
        help(mfilename)
        return
    case 1
        % initialization.  Make Figure Handle.
        
        mp=get(0,'MonitorPositions');
        
        ss=mp(1,1:4);
        
        % let's put figure in upper left corner.       
        figposition=[ss(3)-300 ss(4)-200  300  200];
        


        Hfig=figure('tag','WorldZoomFigure',...
            'IntegerHandle','off',...
            'NumberTitle','off',...
            'Position',figposition',...
            'Name','World Zoom');
        
        % Make World Map
        load MapZoomMapData

        
        SBA=SBA-1;
        surface(longsp,latsp,SBA.'*0,SBA.');
        colormap bone
        shading interp;
        
        
        %%% now set up a post-zoom callback for this window.
        %%% the post-zoom callback for this window will allow user to zoom
        %%% the WorldView (this one) and thus change the axes of all of the
        %%% linked zoom files.
        h=zoom;
        set(h,'ActionPostCallback',@zoomfigcallback);
        set(h,'Enable','on');
                    
        varargout{1}=Hfig;
        return
        
    case 2
        % we have been sent in new X and Y limits.
        % First, though, must check to see if a valid figure exists.
        Hfig=findobj('tag','WorldZoomFigure');
        if length(Hfig)==0
            % don't find a figure.  Need to create.
            Hfig=WorldZoomFunction('Initialize');
        end
        
        if length(Hfig)>1
            warning('Have multiple World Zoom Figures.  Using first one')
            Hfig=Hfig(1);
        end
        
        figure(Hfig);
        
        Haxis=get(Hfig,'children');
        if length(Haxis) > 1
            error('multiple axes in the world figure')
        end
        
        axes(Haxis);
        hold on;

        
        % delete any old axes
        hkill=findobj('tag','WorldZoomBox');
        delete(hkill)
        
        
        % now put a box.
        
        line(newXLim(1)*[1 1],newYLim,'LineWidth',2,'tag','WorldZoomBox');
        line(newXLim(2)*[1 1],newYLim,'LineWidth',2,'tag','WorldZoomBox');
        line(newXLim,newYLim(1)*[1 1],'LineWidth',2,'tag','WorldZoomBox');
        line(newXLim,newYLim(2)*[1 1],'LineWidth',2,'tag','WorldZoomBox');
               
end


function zoomfigcallback(obj,evd)
% this is the post-zoom callback for the world display window.
newXLim = get(evd.Axes,'XLim');
newYLim = get(evd.Axes,'YLim');


hfiglist=get(0,'child');
for j=1:length(hfiglist)
    haxlist=get(hfiglist(j),'child');
    for m=1:length(haxlist);
        h=haxlist(m);
        UD=get(h,'UserData');
        if isstruct(UD)
            if isfield(UD,'WorldZoomConnectedAxis')
                if isequal(getfield(UD,'WorldZoomConnectedAxis'),'yes')
    
                    
                    
                    
    % ok ... this is a worldzoom axis
    set(h,'Xlim',newXLim);
    set(h,'Ylim',newYLim);
    drawnow
                end
            end
        end
    end
end

set(evd.Axes,'Xlim',[-180 180]);
set(evd.Axes,'Ylim',[-90 90]);
WorldZoomFunction(newXLim,newYLim);

    





    