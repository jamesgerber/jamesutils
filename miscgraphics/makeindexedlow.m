function [IM CMAP]=MakeIndexedLow(Image,q)
% MAKEINDEXEDLOW - using simple compression, outputs an indexed image w/
% associated colormap. Slow, but can produce nicely-compressed results.
%
% SYNTAX
% [IM CMAP]=MakeIndexed(Image,q) returns array IM and colormap CMAP
% representing rgb image Image, compressed to degree q (where q is
% the maximum color range to which a value may be assigned - between
% 0 and 1, with 0.001 very low compression and 0.5 very high.
% 
% If memory is not an issue or time is, use MakeIndexed.
%
% EXAMPLE
% image=imread('peppers.png');
% [im cmap]=MakeIndexedLow(image,.2);
% surface(zeros(size(im)),flipud(im),...
%   'FaceColor','texturemap',...
%   'EdgeColor','none',...
%   'CDataMapping','direct')
% colormap(cmap);
%
% See Also
% MakeIndexed
														
Image=ScaleToDouble(Image);
IM=zeros(size(Image,1),size(Image,2),'double');
CNext=1;
CMAP=zeros(0,3,'double');
h = waitbar(0,'Processing');
for i=1:size(Image,1)
    waitbar(i/size(Image,1));
    for j=1:size(Image,2)
        tmp=q*.5;
        pos=0;
        for k=1:size(CMAP,1)
            if (abs(Image(i,j,1)-CMAP(k,1))<tmp&&abs(Image(i,j,2)-CMAP(k,2))<tmp&&abs(Image(i,j,3)-CMAP(k,3))<tmp)
                tmp=max([abs(Image(i,j,1)-CMAP(k,1)) abs(Image(i,j,2)-CMAP(k,2)) abs(Image(i,j,3)-CMAP(k,3))]);
                pos=k;
            end
        end
        if (pos==0)
            CNext=CNext+1;
            CMAP(CNext,:)=[min([Image(i,j,1)+q*.5-mod(Image(i,j,1)+q*.5,q),1.0]) min([Image(i,j,2)+q*.5-mod(Image(i,j,2)+q*.5,q),1.0])...
                min([Image(i,j,3)+q*.5-mod(Image(i,j,3)+q*.5,q),1.0])];
            IM(i,j)=CNext;
        else
            IM(i,j)=pos;
        end
    end
end
CMAP(CMAP<0)=0;
close(h);