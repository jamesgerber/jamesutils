function [lat,long]=optimizeXY(lat,long)
% OPTIMIZEXY - remove duplicate line segments from XY data
%
% SYNTAX
% [newX,newY]=optimizeXY(oldX,oldY);
%

lat(2:(length(lat)+1))=lat(1:length(lat));
lat(1)=NaN;
lat(length(lat)+1)=NaN;
long(2:(length(long)+1))=long(1:length(long));
long(1)=NaN;
long(length(long)+1)=NaN;
L=length(lat);
lat((length(lat)+1):(length(lat)*2))=0;
long((length(long)+1):(length(long)*2))=0;

w=waitbar(0.0,'Breaking duplicate segments...');
i=1;
while i<=(L-1)
    waitbar(i/L,w);
    j=i+1;
    while j<=(L-1)
        if ((~isnan(lat(i))&&~isnan(lat(i+1))&&~isnan(lat(j))&&~isnan(lat(j+1)))...
            &&(((lat(i)==lat(j))&&(lat(i+1)==lat(j+1))&&(long(i)==long(j))&&(long(i+1)==long(j+1)))...
                ||((lat(i+1)==lat(j))&&(lat(i)==lat(j+1))&&(long(i+1)==long(j))&&(long(i)==long(j+1)))))
            lat((i+2):(L+1))=lat((i+1):L);
            lat(i+1)=NaN;
            long((i+2):(L+1))=long((i+1):L);
            long(i+1)=NaN;
            L=L+1;
        end
        j=j+1;
    end
    i=i+1;
end

waitbar(0.0,w,'Removing isolated points...');
i=2;
while i<=(L-1)
    waitbar(i/L,w);
    if (isnan(lat(i-1))&&isnan(lat(i+1)))
        lat(i)=[];
        long(i)=[];
        L=L-1;
    end
    i=i+1;
end

waitbar(0.0,w,'Condensing NaNs...',w);
i=1;
while i<=(L-1)
    waitbar(i/L,w);
    if (isnan(lat(i))&&isnan(lat(i+1)))
        lat(i)=[];
        long(i)=[];
        L=L-1;
    end
    i=i+1;
end
if (isnan(lat(1)))
    lat(1)=[];
    long(1)=[];
    L=L-1;
end
if (isnan(lat(L)))
    lat(L)=[];
    long(L)=[];
    L=L-1;
end
lat=lat(1:L);
long=long(1:L);

delete(w);