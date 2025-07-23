function txt=formatArcASCII(data,filename)
txt=['nrows ' num2str(size(data,2)) '\nncols ' num2str(size(data,1)) '\nxllcorner -180.0\nyllcorner -90.0\ncellsize ' num2str(360.0/size(data,1)) '\n'];
h=waitbar(0.0,'Please wait...');
for j=1:size(data,2)
    waitbar(j/size(data,2),h);
    tmp='';
    for i=1:size(data,1)
        tmp=[tmp ' ' num2str(data(i,j))];
    end
    txt=[txt tmp '\n'];
end
if (nargin>1)
    fid=fopen(filename,'w');
    fprintf(fid,txt);
    fclose(fid);
end
delete(h);