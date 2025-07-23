function lowerFunctions(d)
%LOWERFUNCTIONS - convert all MATLAB scripts and functions in the specified
%directory to lowercase and rewrite code appropriately.
%
%SYNTAX
%lowerFunctions(d) - convert all .m files in directory d to lowercase, and
%rewrite all .m files in directory d so that they will work with the
%changed files.

filenames=fixnames(d)
used=filenames;
used=lowerInstances(d,filenames,used);
used