function geotiffwriteCheesy(filename,MAP)
% make a call to geotiffwrite using tif information stored previously
%
%  Syntax
%    geotiffreadCheesy(filename,raster);
%
%    This function will only work if there was a prior call to
%    geotiffreadCheesy.  That function will store the information necessary
%    to write out the .tif
%
%    This xxxCheesy set of functions is getting around a problem where the
%    GeoKeyDirectoryTag has to be overwritten, but it also serves to make
%    saving the necessary coordinate system information transparent
%
%  See Also:  geotiffwriteCheesy
%
% J Gerber October 2021

[info,R]=geotiffreadCheesy('getinfo')

if isempty(info)
    error([' something wrong.  Was there a prior call to geotiffreadCheesy?'])
end

geotiffwrite(filename,MAP,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag);
