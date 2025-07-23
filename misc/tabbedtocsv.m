function TabbedToCSV(DirString,ExtIn,ExtOut);
%  TABBEDTOCSV  -  Converts tab-delimited to comma delimited
%
%  This function is particularly useful for interpreting data files from
%  PB150 and PB40ES data acquisition systems
%
%  Syntax
%          TabbedToCSV(DirString,ExtIn,ExtOut)
%
%  Example
% 
%         TabbedToCSV('*DAQ1.txt','.txt','.csv');
%
if nargin==0
    help(mfilename)
    return
end;
%DirString='*DAQ1*.txt';
a=dir(DirString);

for m=1:length(a);
    
    FileName=a(m).name;
    fid=fopen(FileName,'r');    
    fout=fopen(strrep(FileName,'.txt','.csv'),'w');

    
    % do the first few lines without considering EOFS.  Sometimes header
    % contains a blank line.
    
    
    line=fgetl(fid)
    
    for mm=1:4
        line=strrep(line,sprintf('\t'),',')
        fprintf(fout,'%s\n',line);
        line=fgetl(fid)
    end
    
    while (line ~=-1)
        
        line=strrep(line,sprintf('\t'),',');
        fprintf(fout,'%s\n',line);
        line=fgetl(fid);
    end

    fclose(fid)
    fclose(fout)
end
