function saveddatafile2nc(filename);
% open a SavedFigureData.mat, put the data into a netcdf
if nargin==0
    a=dir('*SavedFigureData.mat');
    for j=1:length(a);
        saveddatafile2nc(a(j).name);
    end
    return
end


load(filename);

x=OS.Data;

dataname=strrep(filename,'SavedFigureData.mat','');

WriteNetCDF(x,dataname,dataname);

