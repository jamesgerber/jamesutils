function finder(filename)
%FINDER - open a file on path in finder

a=which(filename);

if isempty(a)
    b=fileparts(filename);
else
    b=fileparts(a);
end
unix(['open ' b]);

