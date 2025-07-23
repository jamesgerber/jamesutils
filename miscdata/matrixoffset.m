function O=matrixoffset(I,roff,coff,fill)
% MATRIXOFFSET - vertically and horizontally moves the data in an array
%
% SYNTAX
% matrixoffset(I,roff,coff) moves every element in I roff rows down and
% coff columns right, wrapping data from one side to the other or top to
% bottom.
%
% matrixoffset(I,roff,coff,fill) instead of wrapping data, fills newly
% vacant spaces with fill.
%
% EXAMPLES
% O=matrixoffset(magic(5),2,-1,0)
%
roff=mod(roff,size(I,1));
coff=mod(coff,size(I,2));
O=zeros(size(I));
if (roff>0)
    O((1+roff):size(O,1),:)=I(1:(size(I,1)-roff),:);
    if nargin==3
        O(1:roff,:)=I((size(I,1)-roff+1):size(I,1),:);
    else
        O(1:roff,:)=fill;
    end
end
if (roff<1)
    O(1:(size(O,1)+roff),:)=I((1-roff):size(I,1),:);
    if nargin==3
        O((size(O,1)+roff+1):size(O,1),:)=I(1:-roff,:);
    else
        O((size(O,1)+roff+1):size(O,1),:)=fill;
    end
end
I=O;
if (coff>0)
    O(:,(1+coff):size(O,2))=I(:,1:(size(I,2)-coff));
    if nargin==3
        O(:,1:coff)=I(:,(size(I,2)-coff+1):size(I,2));
    else
        O(:,1:coff)=fill;
    end
end
if (coff<1)
    O(:,1:(size(O,2)+coff))=I(:,(1-coff):size(I,2));
    if nargin==3
        O(:,(size(O,2)+coff+1):size(O,2))=I(:,1:-coff);
    else
        O(:,(size(O,2)+coff+1):size(O,2))=fill;
    end
end