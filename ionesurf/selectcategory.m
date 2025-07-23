function selectCategory(InputFlag)
% selectCategory - helper function to CategorySelectMap
switch(InputFlag)
    case 'Initialize'
        uicontrol('String','Clear','Callback', ...
            'selectCategory(''clear'');','position',NextButtonCoords);
        uicontrol('String','Select Climate','Callback', ...
            'selectCategory(''select'')','position',NextButtonCoords);
    case 'select'
        zoom(gcbf,'off');
        UDS=get(gcbf,'UserData');
        R=[UDS.CellSize,90,-180];
        h=meshm(double(UDS.Back.'),R);
        shading flat;
        colormap(UDS.BMap);
        mx=max2d(UDS.Back);
        caxis(UDS.DataAxisHandle,[1,UDS.BMax+1]);
        set(gcbf,'WindowButtonDownFcn',@SelectClickCallback);
    case 'clear'
        UDS=get(gcbf,'UserData');
        R=[UDS.CellSize,90,-180];
        h=meshm(double(UDS.Data.'),R);
        shading flat;
        colormap(UDS.CMap);
        caxis([1 max2d(UDS.Data)+1])
        max2d(UDS.Data)
        return;
end
end

function SelectClickCallback(src,event)
UDS=get(gcbf,'UserData');
cp=gcpmap(UDS.DataAxisHandle)
[a b]=getRowCol(UDS.Lat,UDS.Long,cp(1,1),cp(1,2));
z=UDS.Data(b,a);
R=[UDS.CellSize,90,-180];
[q w e]=CMapAppend(UDS.BMap*.66,(1+UDS.CMap*5)/6,1,UDS.BMax+1,1,max2d(UDS.Data)+1);
h1=meshm(double(IonEOverlay(UDS.Data*w+e,UDS.Data==z,UDS.Back)).',R);
shading flat;
%    colormap(q);
%    caxis(UDS.DataAxisHandle,[min2d(UDS.Back)-1,(max2d(UDS.Data)+1)*w+e]);
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