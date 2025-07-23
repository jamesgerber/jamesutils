function draw5090(Data,tolerance,thresh1,color1,thresh2,color2)
% DRAW5090 draw a figure highlighting data at the 50th and 90th percentiles
%
%   Syntax:
%   draw5090(Data) plots Data on a Robinson projection and fills in all
%   cells at the 50th and 90th percentiles of the nonzero points with
%   solid color.
%   draw5090(Data,tolerance,thresh1,color1,thresh2,color2) allows
%   modification of the tolerance value, the two thresholds, and the two
%   colors.
%
%   Example:
%
%   S=OpenNetCDF([iddstring 'Crops2000/crops/maize_5min.nc'])
%   tmp=S.Data(:,:,2);  %yield ... not area
%   draw5090(tmp);
%
%   See also fill5090

    if nargin==1
        tolerance=.005;
        thresh1=.5;
        color1=[0.7,0.0,0.7];
        thresh2=.9;
        color2=[0.9,0.9,0.0];
    end
    if nargin==2
        thresh1=.5;
        color1=[0.7,0.0,0.7];
        thresh2=.9;
        color2=[0.9,0.9,0.0];
    end
    if nargin==3
        color1=[0.7,0.0,0.7];
        thresh2=999;
        color2=[0.9,0.9,0.0];
    end
    if nargin==4
        thresh2=999;
        color2=[0.9,0.9,0.0];
    end
    if nargin==5
        color2=[0.9,0.9,0.0];
    end
    color1=rgb(color1);
    color2=rgb(color2);
    load worldindexed;
    Data=fliplr(EasyInterp2(double(Data),4320,2160));
    bmap=immap;
    backdata=rot90(im,3)+1;
    tmp=sort(nonzeros(Data));
    newmap=zeros(length(bmap)+1,3);
    newmap(1,:)=color1;
    newmap(length(newmap)+1,:)=color2;
    for i=1:length(bmap)
        newmap(i+1,:)=bmap(i,:);
    end
    t1low=round(length(tmp)*(thresh1-tolerance));
    if (t1low<1)
        t1low=1;
    end
    if (t1low>length(tmp))
        t1low=length(tmp);
    end
    t1hi=round(length(tmp)*(thresh1+tolerance));
    if (t1hi<1)
        t1hi=1;
    end
    if (t1hi>length(tmp))
        t1hi=length(tmp);
    end
    t2low=round(length(tmp)*(thresh2-tolerance));
    if (t2low<1)
        t2low=1;
    end
    if (t2low>length(tmp))
        t2low=length(tmp);
    end
    t2hi=round(length(tmp)*(thresh2+tolerance));
    if (t2hi<1)
        t2hi=1;
    end
    if (t2hi>length(tmp))
        t2hi=length(tmp);
    end
    backdata(Data>tmp(t1low)&Data<tmp(t1hi))=1;
    backdata(Data>tmp(t2low)&Data<tmp(t2hi))=length(newmap);
    hm=axesm('robinson');
    NumPointsPerDegree=12;
    R=[NumPointsPerDegree,90,-180];
    h=meshm(double(backdata.'),R,[50 100],-1);
    colormap(newmap);
    caxis([1,length(newmap)]);