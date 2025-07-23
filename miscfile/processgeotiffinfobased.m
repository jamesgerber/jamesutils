function [long,lat,raster,info]=processgeotiffinfobased(filename);
% processgeotiffinfobased - load geotiff, put into GLI standard format
%  [long,lat,raster,info]=processgeotiffinfobased(filename,longlatfilename);
%
% %example
%
%filename='~/Downloads/imageToDriveExample.tif';
%[long,lat,raster,info]=processgeotiffinfobased(filename,longlatfilename);


if nargout<3
    warning('need at least 3 args out for this to be useful (long,lat,raster)');
end


info=geotiffinfo(filename);

[A]=geotiffread(filename);
a=A(end:-1:1,:)';


% let's make lon/lat so del has to be positive. then goes from min to max
dellon=abs((info.CornerCoords.Lon(2)-info.CornerCoords.Lon(1))/size(a,1));
dellat=abs((info.CornerCoords.Lat(4)-info.CornerCoords.Lat(1))/size(a,2));

long=(min(info.CornerCoords.Lon)+dellon/2):dellon:max(info.CornerCoords.Lon);
lat=(min(info.CornerCoords.Lat)+dellat/2):dellat:max(info.CornerCoords.Lat);


%[a,R]=geotiffread(longlatfilename);

raster=a;





