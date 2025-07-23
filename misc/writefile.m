function writefile(filename,t,v,HeaderLine,DLM)
% WRITEFILE create a text file of user-defined data
% SYNTAX
%     writefile('foo.dat',t,v)  will create the text file foo.dat
%     containing two columns, which will contain the values of t and v
%     respectively. 
%
% SYNTAX
%     writefile('foo.dat',t,v,HeaderLine)  will prepend a header line
%
%     writefile('foo.dat',t,v,{HeaderLine1,Headerline2, ...})  will prepend a header line
%
%     writefile('foo.dat',t,v,HeaderLine,DLM)  will use DLM as a delimiter
%
%
% Jamie Gerber, OPT  
% August 15, 2001  /Updated Mar 23, 2005

fid=fopen(filename,'w');

if fid==-1
   error('can''t open file')
   return
end

if nargin>3
    if ~iscell(HeaderLine)
        fprintf(fid,'%s\n',HeaderLine);
    else
        for j=1:length(HeaderLine)
            fprintf(fid,'%s\n',HeaderLine{j});
        end    
    end
end

if nargin<5
    DLM=' ';
end


DEV=1
if DEV==1
    %limpa attempt to handle multi-column v
    NumCols=size(v,2);
    FormatString=['%f' ];
    for j=1:(NumCols);
        FormatString=[ FormatString DLM '%f'];
    end
    FormatString=[FormatString ' \n'];
    
    for j=1:length(t);
        fprintf(fid,FormatString,t(j),v(j,1:end));
    end
    
else

try
    % here is some really clunky code to handle the cases where v has 2 or 3 
    % columns.   At some point I should go back and make this generic.
    switch min(size(v))
    case 1
        for j=1:length(t)
            fprintf(fid,'%f    %f  \n',t(j),v(j));
        end
    case 2
        for j=1:length(t)
            fprintf(fid,'%f    %f    %f  \n',t(j),v(j,1),v(j,2));
        end
    case 3
        for j=1:length(t)
            fprintf(fid,'%f    %f    %f    %f  \n',t(j),v(j,1),v(j,2),v(j,3));
        end
    end
catch
   error('problem trying to write the file.  are inputs the same length?')
end
end

fclose(fid);
