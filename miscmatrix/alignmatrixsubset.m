function [targetmatrix]=alignmatrixsubset(long,lat,matrix,targetlong,targetlat,tol,BoundaryValue);
% alignmatrixsubset - get an aligned a subset of a matrix 
%
%
%   [newmatrix]=alignmatrixsubset(long,lat,matrix,targetlong,targetlat,tol,BoundaryValue);
%
%
% see also startmatrixfromsouth startmatrixfromnorth

if nargin==0
    help(mfilename)
    return
end

if nargin<6
    tol=1e-6;
end

if nargin<7
    BoundaryValue=0;
end


if abs(1-mean(diff(long))/mean(diff(targetlong)))>tol
    error([' delta long, delta targetlong out of tolerance (tol = ' num2str(tol) ')']);
end

if abs(1-abs(mean(diff(lat))/mean(diff(targetlat))))>tol
    error([' delta lat, delta targetlat out of tolerance (tol = ' num2str(tol) ')  check north/south']);
    %  figure,plot(targetlat,targetlat,'x'),hold on,plot(lat,lat,'o')
end

% let's first embed long,lat,matrix into something a bit bigger

fatlongminApproximate=min(min(long),min(targetlong));
fatlongmaxApproximate=max(max(long),max(targetlong));

% now snap this to a grid based on deltalong
deltalong=mean(diff(long));
deltalat=mean(diff(lat));
% out of laziness, going to add 100 points in either direction.   Coudl
% figure out what is actually required but punting to future

% how many steps need to add to define fat matrix?
dellowerlat= floor((targetlat(1)-lat(1))/deltalat*1.01);
delupperlat=  ceil((targetlat(end)-lat(end))/deltalat*1.01);

dellowerlong= floor((targetlong(1)-long(1))/deltalong*1.01);
delupperlong=  ceil((targetlong(end)-long(end))/deltalong*1.01);


fatlong  = (long(1)-abs(dellowerlong)*deltalong):deltalong:long(end)+abs(delupperlong)*deltalong;
fatlat   =  (lat(1)-abs(dellowerlat)*deltalat):deltalat:lat(end)+abs(delupperlat)*deltalat;

fatmat=ones(numel(fatlong),numel(fatlat),class(matrix))*BoundaryValue;

% now need to put matrix into fatmatrix
ii1=find(closeto(long(1),fatlong,deltalong*tol));
ii2=find(closeto(long(end),fatlong,deltalong*tol));
jj1=find(closeto(lat(1),fatlat,abs(deltalat)*tol));
jj2=find(closeto(lat(end),fatlat,abs(deltalat)*tol));

if numel([ii1 ii2 jj1 jj2]) ~=4
    error([' some things empty'])
    %  figure,plot(targetlong,targetlong,'x'),hold on,plot(fatlong,fatlong,'o')
    %  figure,plot(targetlat,targetlat,'x'),hold on,plot(fatlat,fatlat,'o')

    %
end

fatmat(ii1:ii2,jj1:jj2)=matrix;


% now can put fatmat onto targetmatrix
% now need to put matrix into fatmatrix
ii1=find(closeto(targetlong(1),fatlong,deltalong*tol));
ii2=find(closeto(targetlong(end),fatlong,deltalong*tol));
jj1=find(closeto(targetlat(1),fatlat,abs(deltalat)*tol));
jj2=find(closeto(targetlat(end),fatlat,abs(deltalat)*tol));
if numel([ii1 ii2 jj1 jj2]) ~=4
    error([' some things empty'])
end
targetmatrix=fatmat(ii1:ii2,jj1:jj2);

