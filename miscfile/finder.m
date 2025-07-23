function finder(filename)
%FINDER - open a file on path in finder

a=which(filename);

b=fileparts(a);

unix(['open ' b]);

