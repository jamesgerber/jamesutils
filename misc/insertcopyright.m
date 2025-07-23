function insertcopyright(filename,newroot);
%insertcopyright - insert BSD copyright into a file
%
%
%  Example
%
% mkdir codetoshare
% insertcopyright('opennetcdf','codetoshare')
% insertcopyright('opengeneralnetcdf','codetoshare')
% insertcopyright('ncdump','codetoshare')
% insertcopyright('writenetcdf','codetoshare')


[RevNo,RevString,LCRevNo,LCRevString,AllInfo]=GetSVNInfo(filename);

x=which(filename);
[PATHSTR,NAME,EXT]=fileparts(x);

newfilename=[newroot '/' NAME  EXT];

tmpdir='.';


fid=fopen(x,'r');
newfid=fopen(newfilename,'w');
crfid=fopen('~/source/matlab/utils/misc/copyright.txt','r');


done=0;

z=fgetl(fid);fprintf(newfid,'%s\n',z);

while ~done
    z=fgetl(fid)
    if length(z)==0
        done=1;
    end
    if done==0
        if ~isequal(z(1),'%')
            done=1;
        end
    end
    
    if done==0
        fprintf(newfid,'%s\n',z);
    end
end
%ok.  that was the end of the header.  now insert copyright.

fprintf(newfid,'\n');
fprintf(newfid,'%%\n');

for j=1:27;
    y=fgetl(crfid);
    fprintf(newfid,'%% %s\n',y);
end
fclose(crfid);

fprintf(newfid,'%%\n');

% now some information about what version this is

fprintf(newfid,['%% svn version %d \n'],RevNo)
fprintf(newfid,'%%\n');


%now tack on the rest of the function

fprintf(newfid,'%s\n',z);

done=0;


while ~done
    z=fgetl(fid);fprintf(newfid,'%s\n',z);
    if isequal(z,-1)
        done=1;
    break
    end
end
fclose(newfid)
fclose(fid)

