function traceContoursGreater(data,thresh,cMap,bg,contourColors,sec)
% TRACECONTOURS - an interactive tool for displaying time-varying data
%
% SYNTAX
% traceContoursGreater(data,thresh,cMap,bg,contourColors) - plots 2d matrix
% bg with colormap cMap and, when user clicks anywhere, finds the value at
% that location and draws contours around areas above that value-thresh
% in every third-dimenion layer of data. Uses colormap contourColors to
% select colors for the contours. Waits sec between drawing contours.
% By default, contourColors is gray, bg is the first layer of data, cMap is
% jet, thresh is 0, and sec is .5
% 
% EXAMPLE
% q=testdata(100,50);
% A=zeros(100,50,10);
% for i=1:6
%    A(:,:,i)=q.*(50-i);
% end
% traceContoursGreater(A)
if (nargin<2)
    thresh=0;
end
data=double(squeeze(data));
if nargin<4
    bg=data(:,:,1);
end
bg=double(bg);
if nargin<3
    cMap=jet;
end
if nargin<5
    contourColors=flipud(gray);
end
if nargin<6
    sec=.5;
end
bg=EasyInterp2(flipud(bg'),540,1080,'linear');
for i=1:size(data,3)
    bdata(:,:,i)=EasyInterp2(flipud(data(:,:,i)'),540,1080,'linear');
end
colormap(cMap);
size(data)
contourColors=EasyInterp2(contourColors,size(data,3),3,'linear')
h=axes; contourf(h,bg,length(cMap)); shading flat; set(h,'Visible','off');
hold on;
%SystemGlobals;
%load(ADMINBOUNDARY_VECTORMAP);
%[long,lat]=LatLong2RowCol(-lat,long,bg');
%line(long,lat,'Color','black');
while ishandle(h)
        waitforbuttonpress;
        cp=get(h,'CurrentPoint');
        r=round(cp(1,2));
        c=round(cp(1,1));
        z=bdata(r,c,1);
        disp([r c z]);
        for i=1:size(bdata,3)
            contourColors(i,:);
            contour(bdata(:,:,i)-z,[thresh thresh],'Linecolor',contourColors(i,:));
            pause(sec);
        end
end
end