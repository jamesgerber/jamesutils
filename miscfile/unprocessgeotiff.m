function unprocessgeotiff(raster,R,filename);
% unprocessgeotiff - save raster into GLI standard format to geotiffformat
% unprocessgeotiff(raster,R,filename);
%
%  see also processgeotiff.m, globalarray2geotiff.m



A=permute(raster,[2,1,3]);  % this unpermutes

geotiffwrite(filename,A,R);
