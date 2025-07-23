function addalphaoutline(OldFileName,NewFileName);
% ADDALPHAOUTLINE - add a transparent channel
%
% SYNTAX
% adalphaoutline(OldFileName,NewFileName) - make all white pixels in
% OldFileName transparent and save the resulting image as NewFileName.
% If NewFileName is unspecified, use <OldFileName>_alpha.png
%
%  Example
%
%   AddAlphaOutline(OLDFILENAME,NEWFILENAME);
%

OldFileName=fixextension(OldFileName,'.png');

plotimage=imread(OldFileName);


if nargin==1
    NewFileName=strrep(OldFileName,'.png','_alpha.png');
end

res=callpersonalpreferences('printingres')
try
    switch res
        case '-r150'
            a=imread([iddstring '/misc/mask/OutputMaskr150.png']);
        case '-r300'
            a=imread([iddstring '/misc/mask/OutputMaskr300.png']);
        case '-r600'
            a=imread([iddstring '/misc/mask/OutputMaskr600.png']);
        otherwise
            error(['don''t know this resolution.'])
    end
catch
    error(['need masks in ' iddstring '/misc/mask/OutputMaskr600.png']);
end



ii=(a(:,:,1)==255 & a(:,:,2) ==255 & a(:,:,3)==255);


Alpha=~ii;

imwrite(plotimage,NewFileName,'png','Alpha',uint8(Alpha*255));

