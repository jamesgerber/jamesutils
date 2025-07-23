function struct2csv(filename,a,dlm);
%struct2csv - make a .csv from a structure of vectors
% 
%   struct2csv(filename,a,dlm);
%
%   dlm optional ',' default
%
%   all fields of a must be numeric.
%   now works for numeric or cell fields - although it's rpetty slow.

if nargin==0
    help(mfilename)
    return
end



if nargin==2
    dlm=',';
end



fn=fieldnames(a)




% first write headerline

fid=fopen(filename,'w');

fprintf(fid,fn{1})
for j=2:numel(fn)
    fprintf(fid,'%s%s',dlm,fn{j});
end
fprintf(fid,'\n');

try
    
    % now create matrix
    
    M=getfield(a,fn{1});
    
    for j=2:numel(fn)
        X=getfield(a,fn{j});
        M(:,j)=X;
    end
    
    %
    fclose(fid)
    dlmwrite(filename,M,'-append','delimiter',dlm,'precision','%f')

catch
    disp(['numeric approach didn''t work, trying to output with strings.  very slow.'])
        
%     ns=struct;  % make a new structure with controlled field names - much easier to code
%     for j=1:numel(fn)    
%         ns=setfield(ns,['f' int2str(j)],getfield(a,fn{j}));
%     end
 
      % make a new structure with controlled field names - much easier to code
    for j=1:numel(fn)   
        x=getfield(a,fn{j});
        if iscell(x);
        ca{j}=x;
        else
          for k=1:numel(x)
              y{k}=x(k);
          end
            ca{j}=y;
        end
    end
 
    % let's make a format string
    formatstring='';
    for j=1:numel(fn)
        if isnumeric(ca{j})
            formatstring=[formatstring '%s,'];
        else
            formatstring=[formatstring '%f,'];
        end
    end
    
    formatstring=formatstring(1:end-1);
    formatstring(end+1:end+2)='\n';

    dlm=',';
    for j=1:numel(ca{1})
        string='';        
        for m=1:numel(fn);
            tmp=ca{m};
            var=tmp{j};
    
            if isnumeric(var) == 1
                var = num2str(var);
                string=[string dlm num2str(var)];
            else
                string=[string dlm var];
            end
        end
        
        
            fprintf(fid,'%s\n',string(2:end));
    end
            
end