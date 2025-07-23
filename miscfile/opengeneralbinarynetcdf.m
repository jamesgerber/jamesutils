function S=readgenericbinarycsv(filename)
% quick code to just pull everything out of a binary .nc file

fileinfo=ncinfo(filename);

%%
for j=1:numel(fileinfo.Variables)
    
    S(j).name=fileinfo.Variables(j).Name;
    S(j).data=ncread(filename,fileinfo.Variables(j).Name);
    S(j).fileinfo=fileinfo;
end

