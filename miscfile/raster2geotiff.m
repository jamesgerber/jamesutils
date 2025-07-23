function raster2geotiff(long,lat,raster,filename);
% function to create geotiffs after making the geoRef structure
A=raster';

% define these first
extentLatCell=abs(mean(diff(lat)));
extentLongCell=abs(mean(diff(long)));


NLat=size(A,1);
NLong=size(A,2);

delLat=[min(lat) max(lat)];
delLong=[min(long) max(long)];
% numerical roundoff may cause the R function to have the wrong raster
% size

% % % construct a testlong
% % testlong=min(long):extentLongCell:max(long);
% % testlat=min(lat):extentLatCell:max(lat);


if lat(1) < lat(end)
    R=georefcells(delLat,delLong,[NLat NLong],'ColumnsStartFrom','South')
else
    R=georefcells(delLat,delLong,[NLat NLong],'ColumnsStartFrom','North')
end
% R = georefcells(delLat,delLong,extentLatCell,extentLongCell);
% 
% if ~isequal(R.RasterSize,size(A))
%     
%     
%     
%     
%     RS=R.RasterSize;
%     AS=size(A);
%     
%     disp([' fiddling '])
%     
%     
%     if RS(2) < AS(2)
%         delLong=[min(long) max(long)]*(1-1e-5);
%     elseif RS(2) > AS(2)
%         delLong=[min(long) max(long)]*(1+1e-5);
%         
%     end
%     
%     if RS(1) < AS(1)
%         delLat=[min(lat) max(lat)]*(1-1e-5);
%     elseif RS(1) > AS(1)
%         delLat=[min(lat) max(lat)]*(1+1e-5);
%         
%     end
%     
%     
%     R = georefcells(delLat,delLong,extentLatCell,extentLongCell);
%     
%     
% end

geotiffwrite(filename,A,R);

