function A=openidd(s)
% OPENIDD - open a specified NetCDF file within the IonE data directory
if isempty(strfind(s,'/'))
    s=['Crops2000/Crop/' s];
end
A=OpenNetCDF([iddstring s]);