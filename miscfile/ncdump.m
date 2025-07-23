function ncdump(FileName)
% NCDUMP - call the unix command ncdump

if nargin==0
 [filename, pathname, filterindex] = uigetfile('*.nc', 'Pick a NetCDF file');
 FileName=[pathname filesep filename];
end


unix(['/usr/local/bin/ncdump -h ' FileName])