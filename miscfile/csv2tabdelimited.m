function csv2tabdelimited(inputfilename,outputfilename,specialcaseflag)
% csv2tabdelimited - prepare a .csv file for reading in with tabs
%
%
%   syntax
%           csv2tabdelimited(inputfilename,outputfilename)
%           csv2tabdelimited(inputfilename)
%
%   if a .csv file has lines like this:  ReadGenericCSV gets confused.
%   0577400,"Almonds, Shelled Basis",AG,"Algeria",2001,2010,10,176,"Ending Stocks",21,"(MT)",0
%
%   this function turns those lines into something like this:
%   0577400	"Almonds, Shelled Basis"	AG	"Algeria"	2001	2010	10	176	"Ending Stocks"	21	"(MT)"	0
%   where those are tabs.
%
%   Note that readgenericcsv has an option to read in a tab-delimited file.
%
%   Note also the following unix command, which will remove all instances
%   of double quotes '"'
%
%     sed  's/"//g' beetox_I_cdl_reclass20210407.csv > beetox_I_cdl_reclass20210407_noquotes.csv
%
%     if the .txt file contains strange characters, then try this:
%     LC_CTYPE=C sed  's/"//g' World2000.txt > World2000nq.txt
%
%
%  See Also:  readgenericcsv

if nargin<3
    specialcaseflag=0;
end
%try
    inputfilename=fixextension(inputfilename,'.csv');

    if nargin==1
        outputfilename=strrep(inputfilename,'.csv','.txt');
    end

    disp(['try this:  '])
    disp(['!   sed  ''s/"//g'' ' outputfilename ' > ' strrep(outputfilename,'.txt','nq.txt')])



    fid=fopen(inputfilename,'r');
    fidout=fopen(outputfilename,'w');
    x=fgetl(fid)
    c=1;
    while x~=-1
        ii=find(x==',');
        jj=find(x=='"');

        putbacktocommas=zeros(size(x));
        for m=1:2:length(jj);
            indices=(jj(m)+1:jj(m+1)-1);

            tmp=x(indices);

            kk=(tmp==',');
            putbacktocommas(indices)=kk;
        end

        xtmp=strrep(x,',',tab);
        xtmp(find(putbacktocommas))=',';

        fprintf(fidout,'%s\n',xtmp);
        x=fgetl(fid);
        c=c+1;

if specialcaseflag==1

    idx= findstr('Extracts, essences and concentrates of tea or mate, and preparations with a basis thereof or with a basis of tea or mat',x);
    if numel(idx)==1
        N=idx+119;

        y=[x(1:N-1) 'e"' x(N+1:end)];
        x=y;
    end


end



    end
    fclose(fid)
    fclose(fidout)
% catch
%     fclose(fid)
%     fclose(fidout)
%     error(['error.  only error I consistently can''t fix is if some special character hides one of the double quotes.' ...
%         'note there is a syntax for this.']);
% end