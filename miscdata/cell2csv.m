function cell2csv(filename,cellArray,delimiter)
% CELL2CSV - Writes cell array content into a *.csv file.
%
%
% SYNTAX:
% CELL2CSV(filename,cellArray,delimiter)
%
% filename = Name of the file to save. [ i.e. 'text.csv' ]
% cellarray = Name of the Cell Array where the data is in
% delimiter = seperating sign, normally: ',' (its default)
%
% by Sylvain Fiedler, KA, 2004
% modified by Rob Kohr, Rutgers, 2005 - changed to english and fixed delimiter
% modified by J. Gerber, U. Minnesota 2010 - allow for strings containing
% '%' and '/'

if nargin==0
    help(mfilename);
    return
end

if nargin<3
    delimiter = ',';
end

datei = fopen(filename,'w');
for z=1:size(cellArray,1)   
    for s=1:size(cellArray,2)
        
        % not sure why this was ever used:
        %   var = eval(['cellArray{z,s}']);
        %replaced with this:
        var = cellArray{z,s};
        
        
        if size(var,1) == 0   
            var = '';
        end
        
        if isnumeric(var) == 1
            var = num2str(var);
        end
        
        % code to replace "\" with "\\", and '%' with '%%' so that fprintf
        % handles it correctly
        
        var=strrep(var,'\','\\');
        var=strrep(var,'%','%%');
        
        fprintf(datei,var);
        
        if s ~= size(cellArray,2)
            fprintf(datei,[delimiter]);
        end
    end
    fprintf(datei,'\n');
end
fclose(datei);