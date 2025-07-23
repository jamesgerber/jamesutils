function outData=IonEAdjust(Data,lat,long,method)
% IONEAdJUST - adjust data to a 4320x2160 global double matrix with the
% right orientation
%
if (nargin==1)
    method='linear';
end
if (nargin==2)
    method=lat;
end
if (nargin==3)
    method='linear';
    bdata=NaN(4320,2160);
    [blong, blat]=InferLongLat(bdata);
    Data=mergedata(bdata,blong,blat,Data,long,lat);
end
Data=double(Data);
if (size(Data,2)>size(Data,1))
    Data=rot90(Data,3);
end
Data=EasyInterp2(Data,4320,2160,method);
mask=LandMaskLogical;
newData=Data;
outData=Data;
fit=0;
for i=1:2
    for j=1:2
        display(['Outside: ' num2str(numel(find((~isnan(newData))&(newData>0)&(newData<999999999999)&(~mask))))]);
        display(['Threshold: ' num2str(numel(find((~isnan(newData))&(newData>0)&(newData<999999999999)))*.2)]);
        if (numel(find((~isnan(newData))&(newData>0)&(newData<999999999999)&(~mask)))<(numel(find((~isnan(newData))&(newData>0)&(newData<999999999999)))*.2))
            display('Fit!');
            if (fit)
                outData=Data;
                return;
            else
                fit=1;
                outData=newData;
            end
        end
        newData=flipud(newData);
    end
    newData=rot90(newData,2);
end