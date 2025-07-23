function varargout=opennetcdf(FileName,force);
% OPENNETCDF - Open a long/lat/data netcdf file
%
%  Syntax
%
%    [Long,Lat,Data]=OpenNetCDF - prompts user for a .nc to open
%
%    [DS]=OpenNetCDF   Will return just a data structure.
%
%    [Long,Lat,Data]=OpenNetCDF(FileName);
%
%    This code will attempt to make a directory call ncmat/ in the location
%    of the .nc file, and will put a .mat file in there which can be used
%    to open the file next time.  uses a bit of extra space on the disk,
%    but it is much faster.  also, the original .nc can be zipped up.
%
%
%  a=dir('*.nc');
%  for j=1:length(a); S=OpenNetCDF(a(j).name); end
%  !gzip *.nc
%
%   See also opengeneralnetcdf, writenetcdf,  convertnetcdfs2mat
%
%
if nargout==0
    help(mfilename)
    return
end

if nargin<2
    force=0;
end

if nargin==0
    InitialGuess='*.nc';
    CallUIGetfile=1;
else
    
    FileName=fixextension(FileName,'.nc');
    
    % see if we can figure out the matlab path file
    [pathstr,name,ext]=fileparts(FileName);
    
    if isempty(pathstr)
        pathstr='.';
    end
    
    MatFileName=[pathstr '/ncmat/' name '.mat'];
    
    
    
    %look and see if FileName exists.
    if exist(FileName,'file') | exist(MatFileName,'file');
        % it exists.  Don't call UIGetFile below.
        CallUIGetfile=0;
        
        
        
    else
        CallUIGetfile=1;
        InitialGuess=(FileName);
    end
    
    
    
end

if CallUIGetfile==1
    if force
        DS.Data=zeros(4320, 2160);
        [DS.Lat DS.Long]=getlatlon(data);
        switch nargout
            case 1
             varargout{1}=DS;
            case 3
             varargout{1}=DS.Long;
             varargout{2}=DS.Lat;
             varargout{3}=DS.Data;
            otherwise
             error
        end
    end
    %we are going to have to call
    [filename,pathname]=uigetfile('*.nc','Pick a NetCDF file',InitialGuess);
    
    if isequal(filename,0)
        error([' no file found.  ' FileName ])
    end
    FileName=[pathname filesep filename];

end

%% look to see if there is a .mat file saved locally
[pathstr,name,ext]=fileparts(FileName);

if isempty(pathstr)
    pathstr='.';
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
else
    OutOfDate=0;
    
end


if exist(MatFileName)==2 & ~OutOfDate
    load(MatFileName)
else
    
    
    % OpenFile
    ncid=netcdf.open(FileName,'NOWRITE');
    
    % some checks to make sure that this is the standard format
    
    [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
    
    if ndims~=4
        error('not expected type of file: ndims ~=4.  Try OpenGeneralNETCDF')
    end
    
    if nvars~=5
        error('not expected type of file: nvars ~=5.  Try OpenGeneralNETCDF')
    end
    
    Var0Name=netcdf.inqDim(ncid,0);
    Var1Name=netcdf.inqDim(ncid,1);
    
    if ~strcmp(lower(Var0Name(1:3)),'lon');
        error('Dimension 0 is not longitude.  Try OpenGeneralNETCDF')
    end
    
    if ~strcmp(lower(Var1Name(1:3)),'lat');
        error('Dimension 1 is not longitude.  Try OpenGeneralNETCDF')
    end
    
    netcdf.close(ncid);
    
    
    ncid=netcdf.open(FileName,'NOWRITE');
    Long=netcdf.getVar(ncid,0);
    Lat=netcdf.getVar(ncid,1);
    Data=netcdf.getVar(ncid,4);
    
    
    DS.Data=Data;
    DS.Long=Long;
    DS.Lat=Lat;
    DS.units='';
    try
        DataVarName=netcdf.inqVar(ncid,4);
        DS.Title=DataVarName;
        
        for j=0:1000 % this will crash, but we are in a try statement
            ThisName=netcdf.inqAttName(ncid,4,j);
            
            
            ThisValue=netcdf.getAtt(ncid,4,ThisName);
            
            if isequal(ThisName(1),'_')
                ThisName=ThisName(2:end);
            end
            DS=setfield(DS,lower(ThisName),ThisValue);
        end
    catch
        %    DS.Title=FileName;
    end
    
    netcdf.close(ncid);
    try
        disp(['saving ' MatFileName]);
        save(MatFileName,'DS')
    catch
        disp(['OpenNetCDF tried to save a shortcut file but it didn''t work']);
    end
    
end

switch nargout
    case 1
        varargout{1}=DS;
    case 3
        varargout{1}=DS.Long;
        varargout{2}=DS.Lat;
        varargout{3}=DS.Data;
        
    otherwise
        error
end



