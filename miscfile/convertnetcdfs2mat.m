function convertnetcdfs2mat
% CONVERTNETCDFS2MAT - recursively save .nc to .mat and gzip the .nc
%
% You would do this if you will mostly be opening these .nc files in matlab
% going forward and want to save space.
%
% This won't work if there are files in the directory whose names start
% with "."  specifically, the first two listings of a "dir" command have to
% be "." and ".."
%
% See also opennetcdf writenetcdf
pwd
a=dir;


if ~isequal(a(1).name,'.')
    error('funny things in directory.');
end

for j=3:length(a)  %first two are self/parent dir
    
    if a(j).isdir
        cd(a(j).name)
        ConvertNetCDFs2mat
        cd ../
    else
        thisname=a(j).name;
        if length(thisname) >3 & isequal(thisname(end-2:end),'.nc')
            disp(['converting ' thisname]);
            try
                S=OpenNetCDF(thisname);
                disp(['compressing ' thisname]);
                dos(['gzip -f ' thisname])
            catch
                S=OpenGeneralNetCDF(thisname);
                disp(['compressing ' thisname]);
                dos(['gzip -f ' thisname])
            end
        end
    end
end