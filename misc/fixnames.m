function filenames=fixnames(d)
% FIXNAMES - a helper function for lowerFunction.  Lowercases all MATLAB
% files in a directory and returns the list of files renamed.
%
% SYNTAX
% filenames=fixnames(d) - renames all files in directory d to their
% lowercase versions and returns sets filenames to the list of files
% changed.
N=dir(d);
filenames={};
for i=1:length(N)
    if (strcmp(N(i).name,'.')+strcmp(N(i).name,'..')+strcmp(N(i).name,'.DS_Store')+strcmp(N(i).name,'.svn')==0)
    if N(i).isdir==1
        fixnames([d '/' N(i).name]);
    else if ~isempty(findstr('.m', N(i).name))
            strrep(N(i).name,'.m','')
            filenames{length(filenames)+1}=strrep(N(i).name,'.m','');
            if (strcmp(lower(N(i).name),N(i).name)==0)
            movefile([d '/' N(i).name],[d '/' lower(N(i).name)]);
            end
        end
    end
    end
end
