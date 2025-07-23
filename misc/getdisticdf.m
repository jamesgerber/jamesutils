function OS=getDist(data,model,sseThresh,nderivs)
if nargin<2
    model='poly3';
end
if nargin<3
    sseThresh=Inf;
end
if nargin<4
    nderivs=2;
end
dataX=(0:(1/(numel(data)-1)):1)';
OS=clusterFit(dataX,sort(data(:)),model,sseThresh,nderivs);