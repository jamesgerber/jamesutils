function tracerplot(data,bg,cmap,ctrace,squeeze,breadth,depth)
% TRACERPLOT - an interactive tool for displaying time-varying global data
%
% SYNTAX
% tracerplot(data,bg,cmap,ctrace,squeeze,breadth,depth) - data is a 3d
% matrix where the third dimension represents time. Draw a map of the
% world with bg as a background, colormap specified by cmap. When the user
% clicks on any location, a line of color ctrace is drawn from near that
% location, tracing the path of the value under the cursor in data(:,:,1)
% to data(:,:,size(data,3)). squeeze is the degree of tolerance of
% variation from the exact value, breadth is the horizontal and vertical
% breadth to look for the value in, and depth is the number of recursions
% to use (greater depth means greater precision).
% All arguments except data are optional; for an argument to be specified,
% all arguments to its left must also be specified. The default bg is
% data(:,:,1) and the default cmap is jet.
% 
% EXAMPLE
% q=testdata(100,50);
% A=zeros(100,50,10);
% for i=1:6
%    A(:,:,i)=q.*(50-i);
% end
% tracerplot(A)
data=double(squeeze(data));
if nargin<2
    bg=data(:,:,1);
end
bg=double(bg);
if nargin<3
    cmap=jet;
end
bg=EasyInterp2(flipud(bg'),540,1080,'linear');
for i=1:size(data,3)
    bdata(:,:,i)=EasyInterp2(flipud(data(:,:,i)'),540,1080,'linear');
end
colormap(cmap);
h=axes; contourf(h,bg,length(cmap)); shading flat; set(h,'Visible','off');
%SystemGlobals;
%load(ADMINBOUNDARY_VECTORMAP);
%[long,lat]=LatLong2RowCol(-lat,long,bg');
%line(long,lat,'Color','black');
while ishandle(h)
    try
        waitforbuttonpress;
        cp=get(h,'CurrentPoint');
        x=round(cp(1,2));
        y=round(cp(1,1));
        axes(h);
        if nargin<4
            tracer(h,x,y,bdata);
        end
        if nargin==4
            tracer(h,x,y,bdata,ctrace);
        end
        if nargin==5
            tracer(h,x,y,bdata,ctrace,squeeze);
        end
        if nargin==6
            tracer(h,x,y,bdata,ctrace,squeeze,breadth);
        end
        if nargin==7
            tracer(h,x,y,bdata,ctrace,squeeze,breadth,depth);
        end
    end
end