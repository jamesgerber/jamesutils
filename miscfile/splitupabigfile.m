function splitupabigfile(filename,Nmax,headerfile)
% splitupabigfile turn a large ASCII file into smaller files for processing
% 
%  SYNTAX
%      splitupabigfile(BigFileName,NumLinesInSmallerFile,HeaderFile)
%
%      HeaderFile is optional.  It is the name of a file with header lines
%      to prepend to the beginning of each of the smaller files.
%  
%  splitupabigfile('pixel_biomass_stats_with_grid_cells.csv',1e6,'megafileheaderline.csv')
%

if nargin==0
    help(mfilename)
    return
end

if nargin<3
    headerfile='';
end

disp(['finding # lines.  this take a while'])
[s,w]=unix(['wc -l ' filename]);

ii=(w==' ');
jj=diff(ii);
k=min(find(jj==1))
Nlines=str2num(w(1:k));
disp(['found #lines=' num2str(Nlines)])

ii=1:Nmax:Nlines
ii(end+1)=Nlines+1;

for j=2:length(ii);
    
    Line1=ii(j-1);
    Line2=ii(j)-1;
    command=['sed -n ' int2str(Line1) ',' int2str(Line2) 'p ' filename ' > tmpfile.xxx'];

    unix(command);
    
    tempfilename=['tempfile_' num2str(j-1) '.csv'];
    
    if isempty(headerfile)
        command=['mv tmpfile.xxx ' tempfilename];
    else
        command=['cat ' headerfile ' tmpfile.xxx > ' tempfilename];
    end
    unix(command); 
end
