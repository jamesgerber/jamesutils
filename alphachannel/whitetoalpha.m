function whiteToalpha(OldFileName,NewFileName,defaultAlpha);
% WhiteToAlpha - replace white with full transparency
%
%  Example
%
%   WhiteToAlpha(OLDFILENAME,NEWFILENAME,DEFAULTALPHA);
%
% if newfilename not given, it will be blahblah_alpha.png
% 
%  optional 3rd argument estables a transparency value for non-white pixels
%  
%  white pixels are those with color >=254 in every channel
%

if nargin<3
    defaultAlpha=0;
end


OldFileName=fixextension(OldFileName,'.png');

plotimage=imread(OldFileName);


if nargin==1
    NewFileName=strrep(OldFileName,'.png','_alpha.png');
end

a=plotimage;

ii=(a(:,:,1)>=254 & a(:,:,2) >=254 & a(:,:,3)>=254);


Alpha=~ii + defaultAlpha*ii;

imwrite(plotimage,NewFileName,'png','Alpha',double(Alpha));%,'Background',ones(size(Alpha)));