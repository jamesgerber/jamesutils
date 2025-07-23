function modifyPoint(InputFlag)

switch(InputFlag)
    case 'Initialize'
        uicontrol('String','Modify Point','Callback', ...
            'modifyPoint(''mod'');','position',NextButtonCoords);     
        uicontrol('String','Get Value','Callback', ...
            'modifyPoint(''val'');','position',NextButtonCoords);   
    case 'mod'
        zoom(gcbf,'off');
        set(gcbf,'WindowButtonDownFcn',@SelectClickCallback);
    case 'val'
        zoom(gcbf,'off');
        set(gcbf,'WindowButtonDownFcn',@ValueClickCallback);
    return;
end
end

function SelectClickCallback(src,event)
    UDS=get(gcbf,'UserData');
    cp=gcpmap(UDS.DataAxisHandle)
    [a b]=getRowCol(UDS.Lat,UDS.Long,cp(1,1),cp(1,2));
    UDS.Data(b,a)=input('Enter value: ');
    ModifiedData=UDS.Data(:,end:-1:1);;
    R=[UDS.CellSize,90,-180];
    h=meshm(double(UDS.Data.'),R);
    save('editoutput.mat','ModifiedData');
    load editoutput
    zoom(gcbf,'on');        
end

function ValueClickCallback(src,event)
    UDS=get(gcbf,'UserData');
    cp=gcpmap(UDS.DataAxisHandle)
    [a b]=getRowCol(UDS.Lat,UDS.Long,cp(1,1),cp(1,2));
    disp(['Value: ' num2str(UDS.Data(b,a))]);
    zoom(gcbf,'on');        
end

function [a b]=getRowCol(LT,LN,lat,lon)
a=1;
while ((LT(a,1)<lat)&&(a<length(LT)))
    a=a+1;
end
b=1;
while ((LN(b,1)<lon)&&(b<length(LN)))
    b=b+1;
end
end