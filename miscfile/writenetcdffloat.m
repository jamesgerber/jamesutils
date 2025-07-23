function writenetcdf(Long,Lat,Data,DataName,FileName,DataAttributeStructure,Force);
%  WRITENETCDF(Long,Lat,Data,DataName,FileName,DataAttributeStructure);
% 
%   SYNTAX:
%            WriteNetCDF(Long,Lat,Data,DataName,FileName);
%
%            WriteNetCDF(Long,Lat,Data,'',FileName); will make DataName
%            equal to FileName (without the directories)
%
%            WriteNetCDF(Long,Lat,Data,DataName,FileName,DataAttributeStructure);
%
%            WriteNetCDF(Long,Lat,Data,DataName,FileName, ...
%                        DataAttributeStructure,Force);
%            
%
%            WriteNetCDF(Data,DataName,FileName);  This syntax will infer
%            Long and Lat
% 
%  DataAttributeStructure is a structure whose field names are the
%  names of attributes of the data variable, and whose values are
%  the values of the attributes
%
%  There is one special case associated with DataAttributeStructure.  If
%  any field name starts with the 10 characters "underscore" then those
%  characaters will be replaced with "_" when the netcdf file is written.
%  This is a work-around to allow users to write attributes with names
%  starting with "_" (e.g. _FillValue, which is required by the NCL script
%  Poisson_Grid_Fill
%
%   Example:
%
%   Long=[-180:180];
%   Lat=[-90:90];
%   Data=  Long(:)*Lat; Data= exp(-Data.^2/40^2);
%   % Create the data attribute structure
%   DAS.units='furlongs';
%   DAS.title='gaussian distribution';
%   DAS.missing_value=-9e10;
%   DAS.underscoreFillValue=-9e10;
%   % Write the file
%   WriteNetCDF(Long,Lat,Data,'TestData','testnetcdffile.nc',DAS);
%
%   %Call unix utility ncdump
%   !/usr/local/bin/ncdump -h testnetcdffile.nc
%
%   See also OPENNETCDF OPENGENERALNETCDF
%

%   I think that this code will crash if FileName is on the path
%   but not in the current directory.

%  JSG
%  Institute on the Environment, University of Minnesota
%  September, 2009
if nargin==0
  help(mfilename)
  return
end

if length(size(Long))>3
    error(['can''t use this syntax with non-2D Data.  Pass in Long,Lat']);
end

if min(size(Long))>1
      
    % first argument is a matrix.  User was too lazy to pass in Long/Lat.
    % Infer Long/Lat, and rename all the matrices so the rest of the code
    % works.
    
    if nargin==4
        DataAttributeStructure=DataName;
    end
    
    if nargin==5
        DataAttributeStructure=DataName;
        Force=FileName;
    end
       
    
    FileName=Data;
    DataName=Lat;
    Data=Long;  % Long was the data matrix.  rename it.
    [Long,Lat]=InferLongLat(Data);  %now make Long and Lat.
end

if ~exist('DataAttributeStructure')
  DataAttributeStructure=[];
end

if ~exist('Force')
  Force='hedge';
end

switch lower(Force)
    case 'force'
        ForceWrite=1;
    case 'query'
        ForceWrite=0;  %do not force writing.  Look to see if file exists.
    case 'hedge'
        ForceWrite=2;  %overwrite, but pause 5 seconds
        
end


FileName=fixextension(FileName,'.nc');

if exist(FileName,'file')==2
    if ForceWrite==0
        disp(['putting up a question dialog'])
        ButtonName = questdlg([FileName ' exists.  Proceed?'], ...
            'File appears to exist',...
            'Overwrite', 'Try Again', 'Cancel', 'Cancel');
        switch ButtonName,
            case 'Overwrite',
                dos(['rm ' FileName]);
            case 'Try Again',
                WriteNetCDF(Long,Lat,Data,DataName,FileName, ...
                    DataAttributeStructure,'query');
                return
            case 'Cancel'
                return
        end
    else
        if ForceWrite==1
            dos(['rm ' FileName]);
        elseif ForceWrite==2
            disp(['About to overwrite ' FileName ])
            pause(4)
            dos(['rm ' FileName]);
        else
            error(['problem in ' mfilename])
        end
    end
end

% determine data class of Data

a=whos('Data');
switch(a.class)
    case 'int8'
        DataVarType='NC_INT';
    case 'single'
        DataVarType='NC_FLOAT';
    case 'double'
        DataVarType='double';
    otherwise
        error(['can''t write this class of data in WriteNetCDF'])
end


NTime=size(Data,4);
NLevel=size(Data,3);


NLong=length(Long);
NLat=length(Lat);

ncid=netcdf.create(FileName,'NC_NOCLOBBER');

LongDim = netcdf.defDim(ncid,'longitude',NLong);
LatDim = netcdf.defDim(ncid,'latitude',NLat);
LevelDim=netcdf.defDim(ncid,'level',NLevel);
%TimeDim=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
TimeDim=netcdf.defDim(ncid,'time',NTime);

if isempty(DataName)
    ii=findstr(FileName,filesep);
    if isempty(ii)
        DataName=strrep(FileName,'.nc','');
    else
        tmp=FileName((max(ii)+1):end);
        DataName=strrep(tmp,'.nc','')
    end
end



LongVarID=netcdf.defVar(ncid,'longitude','double',LongDim);
LatVarID=netcdf.defVar(ncid,'latitude','double',LatDim);
LevelVarID=netcdf.defVar(ncid,'level','double',LevelDim);
TimeVarID=netcdf.defVar(ncid,'time','double',TimeDim);
DataVarID=netcdf.defVar(ncid,DataName,DataVarType,[LongDim LatDim ...
		    LevelDim TimeDim]);

% done with define mode, now enter data mode
netcdf.endDef(ncid);

%now can write data ...
netcdf.putVar(ncid,LongVarID,Long);
netcdf.putVar(ncid,LatVarID,Lat);
netcdf.putVar(ncid,LevelVarID,1:NLevel);
netcdf.putVar(ncid,TimeVarID,1:NTime);
netcdf.putVar(ncid,DataVarID,Data);

MissingValue=-9e9;
% go back to define mode to assign attributes
netcdf.reDef(ncid);
netcdf.putAtt(ncid,LongVarID,'units','longitude');
netcdf.putAtt(ncid,LatVarID,'units','latitude');

if ~isempty(DataAttributeStructure) 
  a=fieldnames(DataAttributeStructure) ;
  for j=1:length(a);
    ThisName=a{j};
    ThisValue=getfield(DataAttributeStructure,ThisName);
    if strmatch(ThisName(1:min(10,length(ThisName))),'underscore')
        netcdf.putAtt(ncid,DataVarID,['_' ThisName(11:end)],ThisValue);
    else
        if ~isempty(ThisValue)
    netcdf.putAtt(ncid,DataVarID,ThisName,ThisValue);
        end
    end
  end
end


% now close access
netcdf.close(ncid);