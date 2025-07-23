function [IM CMAP]=MakeIndexed(Image)
% MAKEINDEXED - create an indexed version of a given rgb image
% with no loss of quality.
%
% SYNTAX
% [IM CMAP]=MakeIndexed(Image) returns array IM and colormap CMAP
% representing rgb image Image.
%
% Use makeindexedlow if the image quality may be reduced and mem
% is an issue.
%
% EXAMPLE
% image=imread('peppers.png');
% [im cmap]=MakeIndexed(image);
% surface(zeros(size(im)),flipud(im),...
%   'FaceColor','texturemap',...
%   'EdgeColor','none',...
%   'CDataMapping','direct')
% colormap(cmap);
%
% See also
% MakeIndexedLow

CMAP=zeros(size(Image,1)*size(Image,2),3);
IM=zeros(size(Image,1),size(Image,2));
CNext=1;
for i=1:size(Image,1)
    for j=1:size(Image,2)
        CMAP(CNext,:)=[Image(i,j,1) Image(i,j,2) Image(i,j,3)];
        IM(i,j)=CNext;
        CNext=CNext+1;
    end
end
CMAP=scaletodouble(CMAP);