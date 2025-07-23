function zoomButtons(InputFlag)
switch(InputFlag)
    case 'Initialize'
        uicontrol('String','Zoom Out','Callback', ...
            'zoomButtons(''zoomout'');','position',NextButtonCoords);  
        uicontrol('String','Zoom','Callback', ...
            'zoomButtons(''zoom'')','position',NextButtonCoords);     
    case 'zoomout'
        zoom(gcbf,'off');
        UDS=get(gcbf,'UserData');
        ha=UDS.DataAxisHandle;
        axes(ha);
            axis 'auto xy'
    case 'zoom'
        zoom(gcbf,'on');
end
end