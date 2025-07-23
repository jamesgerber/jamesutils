function whitetoscaledalpha(OldFileName,NewFileName,ScaleFileName);
% WhiteToAlpha - replace white with full transparency, non-white with 1/2
%
%  SYNTAX
%   whitetoscaledalpha(OldFileName,NewFileName,ScaleFileName) - where
%   OldFileName and ScaleFileName refer to images of the same size, make
%   all pixels in OldFileName where ScaleFileName is white fully
%   transparent and make all other pixels 50% transparent.  If
%   ScaleFileName is unspecified, use OldFileName.  Save the resulting
%   image to NewFileName.  If NewFileName is unspecified, use
%   <OldFileName>_alpha.png.
%


if nargin==1
    NewFileName=strrep(OldFileName,'.png','_alpha.png');
end
if nargin<3
    ScaleFileName=OldFileName;
end

OldFileName=fixextension(OldFileName,'.png');
ScaleFileName=fixextension(ScaleFileName,'.png');

plotimage=imread(OldFileName);

scaleimage=imread(ScaleFileName);


a=plotimage;

ii=(a(:,:,1)>=254 & a(:,:,2) >=254 & a(:,:,3)>=254);


Alpha=(double(255-scaleimage(:,:,1))/255);

imwrite(plotimage,NewFileName,'png','Alpha',double(Alpha));%,'Background',ones(size(Alpha)));