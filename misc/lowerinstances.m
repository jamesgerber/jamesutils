function used=lowerInstances(d,strings,used)
% LOWERINSTANCES - a helper function for lowerFunction. Calls
% lowerInstancesInFile on all files in a directory.

if (nargin==2)
    used=strings;
end
N=dir(d);
for i=1:length(N)
    if (strcmp(N(i).name,'.')+strcmp(N(i).name,'..')+strcmp(N(i).name,'.DS_Store')+strcmp(N(i).name,'.svn')==0)
    if N(i).isdir==1
        used=lowerInstances([d '/' N(i).name],strings,used);
    else if ~isempty(findstr('.m', N(i).name))
            used=lowerInstancesInFile([d '/' N(i).name],strings,used);
        end
    end
    end
end
