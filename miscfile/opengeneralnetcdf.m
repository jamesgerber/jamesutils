function Svector=opengeneralnetcdf(FileName,ncmatdir)
% OPENGENERALNETCDF - Open a general netcdf file
%
%  Syntax
%
%    S=OpenGeneralNetCDF(FileName) will pull all data out of a netcdf file.
%
%    The resulting structure isn't necessarily very much fun to deal with,
%    but at least its in matlab and you can figure things out from the
%    structures
%
%    Default behavior is to create an ./ncmat/ directory and put a matfile
%    with the same name in it.  This allows you to zip up the .nc file
%    which can save space and a lot of time.
%
%    S=OpenGeneralNetCDF(FileName,ncmatdir) will put the ncmat directory in
%    ncmatdir
%   
%
%
%  See also opennetcdf writenetcdf ncdump
if (nargin==0 && nargout~=1)
    help(mfilename)
    Svector=[];
    return
end

if nargin==0
    [filename,pathname]=uigetfile('*.nc','Pick a NetCDF file');
    FileName=[pathname filesep filename];
end

if nargin==1
    FileName=fixextension(FileName,'.nc');
end

%% look to see if there is a .mat file saved locally
[pathstr,name,ext]=fileparts(FileName);

if nargin==1

    if isempty(pathstr)
        pathstr='.';
    end
else
    pathstr=ncmatdir;
end


try
    if ~exist([pathstr '/ncmat/'])
        mkdir([pathstr '/ncmat/']);
        
        
        fid=fopen([pathstr '/ncmat/readme.txt'],'w')
        fprintf(fid,'this directory contains .mat files each of which \n');
        fprintf(fid,'contains the contents of a .nc file from the directory \n');
        fprintf(fid,'above.  See OpenNetCDF.m \n');
        fclose(fid);
    end
catch
    disp(['not able to make '  pathstr '/ncmat/ directory'])
end
MatFileName=[pathstr '/ncmat/' name '.mat'];
if exist(FileName,'file') & exist(MatFileName,'file');
    % if they both exist, check to see who is older
    amat=dir(MatFileName);
    afile=dir(FileName);
    
    if amat.datenum < afile.datenum
        OutOfDate=1;
        disp(['.mat file out of date'])
    else
        OutOfDate=0;
    end
    
    
    % check to make sure it isn't an empty file (which takes place if
    % previous call was to something >2GB
    
    if isequal(amat.bytes,128)
        warning([' inside ' mfilename ])
        disp(' found a mat file, but it is suspiciously small, reloading .nc')
        disp(' typically this means that the variable >2GB and didn''t get saved')
    
        % setting this flag to 1 will force reloading .nc
        OutOfDate=1;
    end
    
    
    
else
    OutOfDate=0;
    
end


if exist(MatFileName)==2 & ~OutOfDate
    load(MatFileName)
else
    
    
    %% OpenFile
    ncid=netcdf.open(FileName,'NOWRITE');
    
    [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
    
    for varid=0:nvars-1
        c=varid+1;
        [varname,xtype,dimids,natts] = netcdf.inqVar(ncid,varid);
        S.varname=varname;
        S.Data=netcdf.getVar(ncid,varid);
        AttS=[];
        for jatt=0:(natts-1);
            [attname] = netcdf.inqAttName(ncid,varid,jatt);
            attrvalue = netcdf.getAtt(ncid,varid,attname);
            AttS(jatt+1).attname=attname;
            AttS(jatt+1).attrvalue=attrvalue;
        end
        S.Attributes=AttS;
        Svector(c)=S;
    end
    %varargout{1}=Svector;
    netcdf.close(ncid);
    
    try
        disp(['saving ' MatFileName]);
        save(MatFileName,'Svector')
    catch
        disp(['OpenNetCDF tried to save a shortcut file but it didn''t work']);
    end
    
end