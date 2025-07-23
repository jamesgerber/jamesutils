function [Xout,Yout]=movePointsToGridCorners(X,Y,rastersizematrix);
% movePointsToGridCorners - reduce resolution of (X,Y) vector 
%
% calling this before calling shapefiletoraster (with the appropriate
% loop) can greatly speed up the call to inpolyon within shapefiletoraster 
% because you can have a situation with a very very high definition polygon
% (I'm looking at you, GADM) which results in inpolygon doing a lot of
% extra work.   If there are multiple polygon points near the same corner
% of a grid cell, can replace with one.  This code attempts to do that.
% There are some weaknesses in it ... not a robust approach to determining
% mulitple points near same grid corner.  Also, I uncovered a case where it
% actually gave different results than not using ... this was some county
% in minnesota ... some really subtle thing with a polygon jumping two
% gridcells, and then depending on the "launch" point from the initial
% gridcell, the polygon goes above or below the intermediate gridcell.  I
% guess a fix for that would be to assure that in a run of points near the
% same corner that the first and last aren't removed. 
%
%  Here's a snippet of code where this sped things up a lot
%
% for j=1:length(d)    
%     j
%    [Xout,Yout]=movePointsToGridCorners(d(j).X,d(j).Y);
% 
%    d(j).X=Xout;
%    d(j).Y=Yout;
%       namecodes3{j}=[d(j).NAME_0 ' ' d(j).NAME_1 ' ' d(j).NAME_2 ' ' d(j).NAME_3];
%     gadm3codes{j}=d(j).GID_3;
%     d(j).newcode=uniqueadminunitcode3(j);
% end
% %
% 
% template=datablank(0,'5min');
% [long,lat,raster3]=shapefiletoraster(d,'newcode',template,0,gadm3codes);
% %
% See Also:  shapefiletoraster
%
%  J. Gerber Mar 2020





persistent Long Lat

if isempty(Long)
    if nargin==2
        disp(['assuming 5 minute raster size matrix'])
        rastersizematrix=datablank;
    end
    [Long,Lat]=inferlonglat(rastersizematrix);
end

delX=mean(diff(Long));
XX=X/delX;

Xinteger=round(XX);

X0=Xinteger*delX;


delY=mean(diff(Lat));
YY=Y/delY;
Yinteger=round(YY);

Y0=Yinteger*delY;


tmp=X0*1000+Y0;


%[~,ii]=unique(tmp,'stable')

jj=find(diff(tmp)~=0);

Xout=X0(jj);
Yout=Y0(jj);
Xout(end+1)=nan;
Yout(end+1)=nan;
makeplot=0;

if makeplot==1
    plot(X,Y,X0,Y0,Xout,Yout);
end








