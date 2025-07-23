function out=IonEZoom(data,rmin,rmax,cmin,cmax)
set(gca,'units','pixels');
vec=get(gca,'position');
a=ceil(vec(3));
b=ceil(vec(4));
out=EasyInterp2(data(rmin:rmax,cmin:cmax),a,b);