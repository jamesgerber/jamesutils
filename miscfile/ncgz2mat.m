function ncgz2mat(filename);
% ncgz2mat  - turn files of form .nc or .nc.gz to .mat files


if nargin==0
    a=dir('*.nc*');
    for j=1:length(a);
        ncgz2mat(a(j).name);
    end
    return
end



[PATHSTR,NAME,EXT] = fileparts(filename) ;
NAME
if isempty(PATHSTR)
    PATHSTR='.';
end
switch EXT
    case '.gz';
        
        try
            S=opengeneralnetcdf([PATHSTR filesep NAME]);
            % if that was successful, it's gzipped and there's a .ncmat
            return
        catch
            disp([' need to unzip/open/rezip ' filename ]);
            dos([ ' gzip -d ' PATHSTR filesep NAME EXT]);
            
             S=opengeneralnetcdf([PATHSTR filesep NAME]);
             
             dos([ ' gzip  ' PATHSTR filesep NAME ]);
        end
    case '.nc'
        S=opengeneralnetcdf([PATHSTR filesep NAME EXT]);
             dos([ ' gzip  ' PATHSTR filesep NAME EXT]);
    otherwise
        error
end

