function output=processshapefile(S,field,scale,outfile)

short=round(8384*scale);
long=round(9182*scale);
output=zeros(short,long);
X=zeros(short,long);
Y=zeros(short,long);
        for i=1:long
            X(1:short,i)=i;
        end
        for i=1:short
            Y(i,1:long)=i;
        end
for seek=1:20
h=waitbar(0,['This may take a while... task ' num2str(seek) '/9']);
polyx=[];
polyy=[];
for i=1:length(S)
    if ((eval(['S(', num2str(i), ').', field]))==seek)
        waitbar(i/length(S),h);
        output=output+double((output==0)).*inpolygon(X,Y,((S(i).X+4463000)/(4463000+4639000))*long,((S(i).Y+4000000)/(4000000+4384000))*short)*seek;
        polyx=[polyx S(i).X];
        polyy=[polyy S(i).Y];
    end
end
try
    close(f)
end
line(polyx,polyy)
f=gcf;
close(h)
end
%output=inpolygon(X,Y,((polyx+4463000)/(4463000+4639000))*9102,((polyy+4000000)/(4000000+4384000))*8384);

if (nargin==4)
    save(outfile,'polyx','polyy','output');
end
    
close(f)

% 
% function [xred,yred]=DownSample(x,y,minkmsq,thinninglength);
% 
% xkm=x*(40075/360);
% ykm=y*(40075/360);
% 
% AreaSquareDegrees=polyarea(x,y);
% Areakmsq=AreaSquareDegrees*(40075/360)^2*cosd(mean(y));
% 
% 
% if Areakmsq < minkmsq;
%     xred=[];
%     yred=[];
%     return
% end
% 
% if thinninglength ==0
%     xred=x;
%     yred=y;
%     return
% end
% 
% % now go through and smooth over any points that are within 1km of
% % each other.
% 
% MinDistance=thinninglength;
% 
% c=1;
% done=0;
% 
% xred=-190*ones(1,1e5);
% yred=-190*ones(1,1e5);
% 
% xred(1)=x(1);
% yred(1)=y(1);
% xredlength=1;
% 
% while ~done
%     
%     z=((xkm(c:end)-xkm(c)).^2+(ykm(c:end)-ykm(c)).^2).^(1/2);
%     ii=min(find(z>=MinDistance));
%     
%     if ~isempty(ii)
%         xredlength=xredlength+1;
%         xred(xredlength)=x(c+ii-1);
%         yred(xredlength)=y(c+ii-1);
%         
%         c=c+ii-1;
%     else
%         done=1;
%     end
%     
% end
% 
% xred=xred(1:xredlength);
% yred=yred(1:xredlength);
% xred(end+1)=xred(1);
% yred(end+1)=yred(1);    
