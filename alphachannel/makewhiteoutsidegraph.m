function MakeWhiteOutsideGraph(OldFileName,NewFileName);
% MakeWhiteOutsideGraph - add a transparent channel
%
%  Example
%
%   MakeWhiteOutsideGraph(OLDFILENAME,NEWFILENAME);
%
%  See also AddAlphaOutline

OldFileName=fixextension(OldFileName,'.png');

plotimage=imread(OldFileName);


if nargin==1
    NewFileName=strrep(OldFileName,'.png','_whiteout.png');
end

a=plotimage;

res=['size' num2str(size(a,1)) '_' num2str(size(a,2))];


FileName=[iddstring '/misc/mask/OutputMask_colorbar_' res '.png'];


%try
   a=imread(FileName);
%catch
%    error(['need masks in ' iddstring '/misc/mask/OutputMaskr600.png']);
%end



ii=(a(:,:,1)==255 & a(:,:,2) ==255 & a(:,:,3)==255);

tmp=plotimage(:,:,1);
tmp(ii)=255;
plotimage(:,:,1)=tmp;
tmp=plotimage(:,:,2);
tmp(ii)=255;
plotimage(:,:,2)=tmp;
tmp=plotimage(:,:,3);
tmp(ii)=255;
plotimage(:,:,3)=tmp;

imwrite(plotimage,NewFileName);