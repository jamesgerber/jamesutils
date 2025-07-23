function cblabel(text)
% CBLabel - colorbar label for a figure made with IonESurf, etc. code
%
%

if ~isequal('IonEFigure',get(gcf,'tag'));
    warning(['Not an IonEFigure.  Don''t know how to find colorbar'])
    return
end
fud=get(gcf,'UserData');

set(fud.ColorbarStringHandle,'String',['  ' text '  ']);
set(fud.ColorbarStringHandle,'fontsize',12);
