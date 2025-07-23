function fill5090(Data,thresh1,color1,thresh2,color2)
% DRAW5090 draw a figure highlighting data above the 50th and 90th percentiles
%
%   Syntax:
%   draw5090(Data) plots Data on a Robinson projection and fills in all
%   cells at the 50th and 90th percentiles of the nonzero points with
%   solid color.
%   draw5090(Data,thresh1,color1,thresh2,color2) allows
%   modification of the two thresholds and the two colors.
%
%   Example:
%
%   S=OpenNetCDF([iddstring 'Crops2000/crops/maize_5min.nc'])
%   tmp=S.Data(:,:,2);  %yield ... not area
%   fill5090(tmp);
%
%   See also draw5090

    if nargin==1
        thresh1=.5;
        color1=[0.7,0.0,0.7];
        thresh2=.9;
        color2=[0.9,0.9,0.0];
    end
    if nargin==2
        color1=[0.7,0.0,0.7];
        thresh2=.9;
        color2=[0.9,0.9,0.0];
    end
    if nargin==3
        thresh2=999;
        color2=[0.9,0.9,0.0];
    end
    if nargin==4
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
    t1low=round(length(tmp)*(thresh1));
    if (t1low<1)
        t1low=1;
    end
    if (t1low>length(tmp))
        t1low=length(tmp);
    end
    t2low=round(length(tmp)*(thresh2));
    if (t2low<1)
        t2low=1;
    end
    if (t2low>length(tmp))
        t2low=length(tmp);
    end
    backdata(Data>tmp(t1low))=1;
    backdata(Data>tmp(t2low))=length(newmap);
    hm=axesm('robinson');
    NumPointsPerDegree=12;
    R=[NumPointsPerDegree,90,-180];
    h=meshm(double(backdata.'),R,[50 100],-1);
    colormap(newmap);
    caxis([1,length(newmap)]);