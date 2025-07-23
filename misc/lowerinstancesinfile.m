function used=lowerInstancesInFile(filename,strings,used)
% LOWERINSTANCESINFILE - find strings in a file and convert to lowercase.
% Return a list of all specified strings not found.
%
% SYNTAX
% a=lowerInstancesInFile(filename,strings) - overwrite the file
% specified by filename with a new file in which all instances of one of
% the specified strings are in lowercase, and set a to the list of all
% specified strings that were not encountered.
%
% used=lowerInstnacesInFile(filename,strings,used) - this is a special form
% to help lowerFunction. Used should be the same length as strings; when a
% string in strings is found, its index in used will be cleared.

if nargin==2
    used=strings;
end
ourfile = fileread(filename);
for i=1:length(strings)
    ourfile=strrep(ourfile,strings{i},lower(strings{i}));
    if ~isempty(strfind(ourfile,strings{i}))
        used{i}='';
    end
end
disp(filename)
fprintf(fopen(filename,'w'),'%s',ourfile)