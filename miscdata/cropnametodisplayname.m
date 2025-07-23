function displayname=cropnametodisplayname(cropname)
% CROPNAMETODISPLAYNAME make an image-friendly name  
%
%  This code is kind of silly - need to write something like
%  FAONamesToSageNames
%
% first special cases
switch lower(cropname)
    case 'pumpkinetc'
        cropname='Pumpkin, squash and gourds';
    case 'greenpeas'
        cropname='Green Pea';
    case 'bean'
        cropname='Bean (black)';
    case 'oats'
        cropname= 'oat';
    case 'oilpalm'
        cropname= 'oil palm';
    case 'sugarcane'
        cropname= 'sugar cane';
    otherwise
        cropname=cropname;
end

cropname=char(cropname);

cropname=strrep(cropname,'nes',' not otherwise included');
    
cropname=strrep(cropname,'for',' forage ');

cropname=strrep(cropname,'etc',' etc.');




displayname=cropname;
