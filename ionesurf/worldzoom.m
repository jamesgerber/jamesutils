function WorldZoom(Hfig);
% WORLDZOOM - Link to a world map which can show navigation 

% based on zoom demo 


if nargin==0
    Hfig=gcf;
end

figure(Hfig);

% now attach some userdata to every axis
% however, ignore axes with a tag (probably a legend or colorbar)
hlist=get(Hfig,'Child');
for j=1:length(hlist);
    if ( ...
            isequal(get(hlist(j),'type'),'axes') ...
            & ...
            isequal(get(hlist(j),'tag'),'') ...
            )
        
        
        UD=get(hlist(j),'UserData');
        UD.WorldZoomConnectedAxis='yes';
        set(hlist(j),'UserData',UD);
    end
end

h = zoom;
%set(h,'ActionPreCallback',@myprecallback);
set(h,'ActionPostCallback',@mypostcallback);
set(h,'Enable','on');
WorldZoomFunction([-180 180],[90 90])
%function myprecallback(obj,evd)
%disp('A zoom is about to occur.');

function mypostcallback(obj,evd)
newXLim = get(evd.Axes,'XLim');
newYLim = get(evd.Axes,'YLim');
drawnow  
%this drawnow addresses a problem ... otherwise the order of things seems
%to get screwed up in that Matlab starts processing this call back before
%it has updated the axes.  This seems to fix a problem I was having.


WorldZoomFunction(newXLim,newYLim);