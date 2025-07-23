function [R,C]=tracer(h,ri,ci,data,ctrace,squeeze,breadth,depth)
% TRACER - draw a line on the given axes tracing the path of a given value
% over time. Designed as a helper function to tracerplot.
%
% SYNTAX
% tracer(h,ri,ci,data,ctrace,squeeze,breadth,depth) - draw a line on axes
% h, starting near ri,ci. Looks at the value at data(ri,ci,1) and traces
% the path taken by that value over time, assuming that the third dimension
% of data represents time. ctrace is the color of the line. squeeze
% represents the degree of tolerance of variation from the given value,
% breadth is the horizontal and vertical breadth to search for the value
% in, and depth is the number of recursions to apply for greater precision.
%
% All arguments except h, ri, ci, and data are optional. For an argument to
% be specified, all arguments to its left must also be specified. The
% default color is a light blue, the default squeeze is the standard
% deviation, the default breadth is one tenth the largest dimension, and
% the default depth is 1.
%
% EXAMPLE
% % average monthly temperatures over an elevation map
% ES=OpenGeneralNetCDF('elev.1-deg.nc');
% elev=matrixoffset(ES(1,4).Data,180,0);
% DS=OpenGeneralNetCDF('absolute.nc');
% temp=DS(1,1).Data;
% tracerplot(temp,elev,gray);
if nargin<5
    ctrace=[0.6784,0.9216,1.0000];
end
if nargin<6
    squeeze=std2(data);
end
if nargin<7
    breadth=length(data(:,:,1))/10;
end
if nargin<8
    depth=1;
end
R=[ri];
C=[ci];
val=data(round(ri),round(ci),1);
for i=1:size(data,3)
    [ri,ci]=center(data(:,:,i),val,squeeze,ri,ci,breadth,depth);
    axes(h);
    if (i>1)
        R(length(R)+1)=ri;
        C(length(C)+1)=ci;
        line(C((i-1):i),R((i-1):i),'LineWidth',2,'Color',ctrace);
    end
end