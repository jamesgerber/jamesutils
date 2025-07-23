function sage=getoutlines
% GETOUTLINES - get global administrative boundaries
SystemGlobals;
path = [IoneDataDir 'AdminBoundary2005/Raster_NetCDF/' ...
    '3_M3lcover_5min/admincodes.csv'];
admincodes = ReadGenericCSV(path);

sagecodes = unique(admincodes.SAGE_ADMIN);

sage=cell(4320,2160);

l=length(sagecodes);

for c = 1:l;
    disp((c/l)*100.0);
    ccode = sagecodes{c};
    [a,b]=find(CountryCodetoOutline(ccode));
    for i=1:length(a)
        sage{a(i),b(i)}=ccode;
    end
end