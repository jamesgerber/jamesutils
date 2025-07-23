function compresstif(oldfilename,newfilename,tempfilename);
% function compresstif use gdal_translate to compress a tif
%
%  compresstif(oldfilename,newfilename,tempdir);


if nargin<3
    tempfilename='~/compresstiftempfile.tif';
end

if nargin<2
    newfilename=oldfilename;
end

gdalcommand='/usr/local/bin/gdal_translate';

unix(['cp ' oldfilename ' ' tempfilename]);
unix([gdalcommand ' -co "COMPRESS=DEFLATE"  ' ...
    tempfilename ' ' newfilename ]);
