function excel(filename,numfiles)
% excel - open filename in excel
%
% allows me to open a .txt file that way
% (if csv, then !open filename.csv better)
%
% Syntax
%  excel filename
%
%  excel 1   (will open file with latest timestamp)
%
%  excel dirname 2 (will open 2 files with latest datestamp)
%
%  This function is very brittle - doesn't check to assure that files it
%  sends to excel are .csv or .xlsx or .xls



if nargin==0
    help(mfilename)
    return
end

if nargin==1
   % if isequal(nargin,'1')
        
    numfiles=1;
else
    numfiles=str2num(numfiles);
end

if isequal(filename(end),filesep)
    % opening a directory
   
    dirname=filename;
    
    a=dir([filename]);
    
    
    for nn=1:numfiles;
    
    [~,iisort]=sort([a.datenum],'descend');
    idx=iisort(nn);
    filename=[dirname a(idx).name]
    unix(['open -a /Applications/''Microsoft Excel.app''/ ' filename]);
    end
else
    unix(['open -a /Applications/''Microsoft Excel.app''/ ' filename]);
end

   

