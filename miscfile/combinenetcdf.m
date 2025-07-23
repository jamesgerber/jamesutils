function CombineNetCDF(AreaFile,YieldFile,OutputFile,DAS);
% COMBINENETCDF - combine matrices in two netcdf files
%
%  Syntax
%
%   CombineNetCDF(FirstFile,SecondFile,OutputFile); will create a
%   .netcdf file out of the files names AreaFile and YieldFile
%
%   AreaFile must be accessible with OpenNetCDF via the syntax
%   [Long,Lat,AFData]=OpenNetCDF(AreaFile);
%
%   AFData must be m x n x p
%   YFData must be m x n x 1
%
%   For example, CombineNetCDF(AreaLayerFile,YieldLayerFile,OutputFile,DAS);
%   will result in a two-layer netcdf consistent with Monfreda et
%   al data.
AF=OpenNetCDF(AreaFile);
YF=OpenNetCDF(YieldFile);


%% Check to see if dimesions are the same

if ~isequal(size(AF.Data,1),size(YF.Data,1))
  error('size of layers not the same')
end
if ~isequal(size(AF.Data,2),size(YF.Data,2))
  error('size of layers not the same')
end
if length(size(AF.Data))>2
  error('appended file must be 2D')
end


newdata(:,:,:)=AF.Data;
newdata(:,:,end+1)=YF.Data;


WriteNetCDF(AF.Long,AF.Lat,newdata,'Data',OutputFile,DAS);

