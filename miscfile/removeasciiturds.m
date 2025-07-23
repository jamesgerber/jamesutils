function cleanstring=removeasciiturds(dirtystring);
% removeASCIIturds - remove 'extended' ASCII codes
%  
% Code is particularly useful when comparing strings read in from a
% shapefile since ARCGIS seems to handle extended ASCII differently from
% Excel.
%
%  This code calls ASCII2Integer - which is an inefficient code that I
%  wrote.  Someone could make this much faster (and vectorizable)
%
%    cleanstring=removeasciiturds(dirtystring);
keepme=[];
for j=1:length(dirtystring)
    m=ASCII2Integer(dirtystring(j));
    
    if m<=128
        keepme=[keepme j];
    end
end
cleanstring=dirtystring(keepme);

