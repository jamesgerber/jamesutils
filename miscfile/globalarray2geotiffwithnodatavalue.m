function filename=globalarray2geotiffwithnodatavalue(raster,filename,nodatavalue)
% globalarray2geotiff - converts a raster into a geotiff file  
% 
%  globalarray2geotiff(raster,filename);
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

 if min(size(raster))==1
     error('something wrong - this is a vector ')
 end


filename=fixextension(filename,'.tif');


rasterforwriting=raster';

% let's spit out a warning in case filename is very recent
a=dir(filename);

if ~isempty(a)
    ageoffileindays=now-a.datenum;

    if ageoffileindays*24*60*60<60
        warndlg([' about to write over ' filename ' which is less than 60 seconds old.  Intentional?'])
    end
end


% default compression is PackBits - it turns out LZW better web graphics,
% so i'm hardcoding this change here.  oops.  JSG Jan 31, 2025
% old code:
%geotiffwrite(filename,rasterforwriting,R);

%keyboard

%TiffTags.Compression='LZW';
%geotiffwrite(filename,rasterforwriting,R,'TiffTags',TiffTags);


minval=nanmin(raster(:));

nodatainteger=min(floor(minval-100),-9999);

rasterforwriting(isnan(rasterforwriting))=nodatainteger;


TiffTags.Compression='LZW';
geotiffwrite('tmp.tif',rasterforwriting,R,'TiffTags',TiffTags);


% chatGPT helped me with the following line
%gdal_calc.py --overwrite --co="COMPRESS=LZW" -A tmp.tif --outfile=tmp_nan.tif --calc="numpy.where(A==-99, numpy.nan, A)" --NoDataValue=nan

evalme=['/opt/miniconda3/bin/gdal_calc.py --overwrite --co="COMPRESS=LZW" -A tmp.tif --outfile=' filename ' --calc="numpy.where(A==' int2str(nodatainteger) ', numpy.nan, A)" --NoDataValue=nan'];

%disp(evalme)
disp(['calling gdal_translate to standardize handling of nans'])
unix(evalme);
