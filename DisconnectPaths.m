wd=which(mfilename)

base=wd(1:end-17);

a=dir(base);

ii=find([a.isdir]);

for j=ii
    if ~strcmp(a(j).name(1),'.')
        rmpath([base a(j).name]);
    end
end

