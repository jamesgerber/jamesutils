function [xkeep,ykeep]=ShapeFileToXY(S,minkmsq,thinninglength)
% SHAPEFILETOXY - turn a shapefile structure into x/y that would lead to a
% map
%
%   Syntax 
%
%      [xkeep,ykeep]=ShapeFileToXY(S) where S is the output from a 
%      SHAPEREAD command (mapping toolbox) will produce a vector which can
%      be plotted in matlab to produce the outline defined by the polygons
%      of S.
%
%      [xkeep,ykeep]=ShapeFileToXY(S,minkmsq,thinninglength) will omit any
%      polygons whose enclosed area (determined by polyarea) is less than
%      minkmsq (default 200), and will smooth out multiple points within
%      thinning length of each other.
%

if nargin==1
    minkmsq=200;
    thinninglength=0;  %no thinning
end

xkeep=[];
ykeep=[];
for j=1:length(S);
    X=S(j).X;
    Y=S(j).Y;
    
    ii=find(isnan(X));
    jj=find(isnan(Y));
    
    if ~isequal(ii,jj)
        error('NaN values don''t align')
    end
    
    ii=[0 ii length(X)+1];
    for m=1:length(ii)-1;
        
        x=X(ii(m)+1:ii(m+1)-1);
        y=Y(ii(m)+1:ii(m+1)-1);
        if isempty(x)
            xred=x;
            yred=y;
        else
            [xred,yred]=DownSample(x,y,minkmsq,thinninglength);
        end
        if ~isempty(xred)
            xkeep=[xkeep NaN xred];
            ykeep=[ykeep NaN yred];
            
            %    plot(x,y,xred,yred,'r')
            %    hold on
            %    axis([-2 2 -1 1]*90)
            %    cf
            %    m
        end
    end
end


function [xred,yred]=DownSample(x,y,minkmsq,thinninglength);

xkm=x*(40075/360);
ykm=y*(40075/360);

AreaSquareDegrees=polyarea(x,y);
Areakmsq=AreaSquareDegrees*(40075/360)^2*cosd(mean(y));


if Areakmsq < minkmsq;
    xred=[];
    yred=[];
    return
end

if thinninglength ==0
    xred=x;
    yred=y;
    return
end

% now go through and smooth over any points that are within 1km of
% each other.

MinDistance=thinninglength;

c=1;
done=0;

xred=-190*ones(1,1e5);
yred=-190*ones(1,1e5);

xred(1)=x(1);
yred(1)=y(1);
xredlength=1;

while ~done
    
    z=((xkm(c:end)-xkm(c)).^2+(ykm(c:end)-ykm(c)).^2).^(1/2);
    ii=min(find(z>=MinDistance));
    
    if ~isempty(ii)
        xredlength=xredlength+1;
        xred(xredlength)=x(c+ii-1);
        yred(xredlength)=y(c+ii-1);
        
        c=c+ii-1;
    else
        done=1;
    end
    
end

xred=xred(1:xredlength);
yred=yred(1:xredlength);
xred(end+1)=xred(1);
yred(end+1)=yred(1);    


