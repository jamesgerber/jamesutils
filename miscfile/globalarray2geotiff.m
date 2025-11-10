function filename=globalarray2geotiff(raster,filename,readmetext)
% globalarray2geotiff - converts a raster into a geotiff file  
% 
%  globalarray2geotiff(raster,filename);
%
%  globalarray2geotiff(raster,filename,readmetext);
%
%
% If the longitude latitude arrays are not inputted (varargs)
% Raster must be a raster of the earth
%

% Written by Sam Stiffman
% Last Edited 7/8/2019

 latlim = [-90 90];
 lonlim = [-180 180];
 
 raster=raster(:,end:-1:1);
 
 R = georefcells(latlim,lonlim,size(raster'));



filename=fixextension(filename,'.tif');


rasterforwriting=raster';

% default compression is PackBits - it turns out LZW better web graphics,
% so i'm hardcoding this change here.  oops.  JSG Jan 31, 2025
% old code:
%geotiffwrite(filename,rasterforwriting,R);

TiffTags.Compression='LZW';
geotiffwrite(filename,rasterforwriting,R,'TiffTags',TiffTags);

if nargin<3
    return
end

% ok ... we have some 'readme' text, store that in a 'readme' file.

readmefilename=strrep(filename,'.tif','_README.txt');

try
    stack=dbstack;
    callingfilename=stack(2).name;
catch
    callingfilename='base';
end

fid=fopen(readmefilename,'w');

fprintf(fid,'%s\n',readmetext);
fprintf(fid,'%s\n',['created on ' datestr(now) ' working dir ' pwd ]);
fprintf(fid,'%s\n',['called from function ' callingfilename ]);
fprintf(fid,'%s\n',['which lived in ' which(callingfilename) ]);
fclose(fid);



