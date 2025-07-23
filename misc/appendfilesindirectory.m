function appendfilesindirectory(dir,fname)
% APPENDFILESINDIRECTORY - append all files in specified directory into a
% single file. Good for combining lists and spreadsheets.
%
% SYNTAX
% appendfilesindirectory(dir,fname) - append all files in directory dir
% into a file specified by fname.
% appendfilesindirectory(dir) - append all files in directory dir into a
% file called 'output.csv'
% appendfilesindirectory - append all files in the current directory into a
% file called 'output.csv'
if nargin<2
    fname='output.csv';
end
olddir=cd;
if nargin>0
    cd(dir);
end
N=dir;
for i=1:length(N)
    if (strcmp(N(i).name,'.')+strcmp(N(i).name,'..')+strcmp(N(i).name,'.DS_Store')+N(i).isdir==0)
        file=[file,fileread(N(i).name)];
    end
end
file
cd(olddir);
fprintf(fopen(fname,'w'),'%c',file);