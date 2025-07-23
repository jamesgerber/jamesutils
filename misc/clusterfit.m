function OS=clusterFit(X,Y,model,sseThresh,nderivs,last)
% CLUSTERFIT - segmented regression based on kmeans clustering
%
% SYNTAX
% OS=clusterFit(Y)
% OS=clusterFit(X,Y,model,sseThresh,nDerivs) - model is a string
% representing the model to be used and can be anything accepted by fit.
% sseThresh is the SSE threshold above which the data will be split into
% multiple clusters, perhaps recursively.  nDerivs is the number of
% derivatives to take into account when clustering.
% model defaults to 'poly3', sseThresh defaults to infinity, and nDerivs
% defaults to 2.
% Returns a structure containing the expressions used to fit the data and
% their ranges.
%
% EXAMPLE
% clusterFit(0:.1:10,sin(0:.1:10)+(0:.1:10),'poly2',10)
%

if (nargin<2)
    Y=X(:);
    X=1:numel(X);
end
if (nargin<3)
    model='poly3';
end
if (nargin<4)
    sseThresh=Inf;
end
if (nargin<5)
    nderivs=2;
end
if (nargin<6)
    last=Inf;
end
X=X(:);
Y=Y(:);
% if (numel(X)<numparam)
%     display(['Insufficient data for ' num2str(numparam) ' parameters...']);
%     OS=[];
%     return;
% end
try
    [t,gof]=fit(X,Y,model);
catch err
    display('Can''t fit...');
    OS=[];
    return;
end
display(['SSE: ' num2str(gof.sse) ' N: ' num2str(numel(X)) ' MeanX: ' num2str(mean(X)) ' MeanY: ' num2str(mean(Y))]);
if (gof.sse>last)
    display('SSE increase...');
    OS=[];
    return;
end
if (gof.sse>sseThresh)
    %IDX=kmeans([X/sqrt(var(X)),Y/sqrt(var(Y)),approxDeriv(Y/sqrt(var(Y)))./approxDeriv(X/sqrt(var(X)))],2,'replicates',replicates,'emptyaction','singleton');
    kmX=[X/sqrt(var(X)),Y/sqrt(var(Y))];
    for i=1:nderivs
        kmX=[kmX,(approxDeriv(kmX(:,size(kmX,2)))./approxDeriv(kmX(:,1)))/(size(kmX,2)-1)];
%        kmX=[kmX,interp1((1:(size(kmX,1)-1))',diff(kmX(:,size(kmX,2)-1)),(1:size(kmX,1))'-.5,'spline','extrap')];
    end
    for i=1:size(kmX,2)
        kmX(:,i)=kmX(:,i)/sqrt(var(kmX(:,i)));
    end
    kmX(kmX==Inf)=0;
    IDX=kmeans(kmX,2,'replicates',20);
    if (IDX(1)==2)
        IDX=3-IDX;
    end
    [dummy,div]=min(abs((length(IDX)-1)/2-(diff(IDX)>0).*(1:(length(IDX)-1))'));
    display(['Clustering... ' num2str(length(find(IDX(1:div)))) ' '  num2str(length(find((div+1):length(IDX))))]);
    if (max(X(1:div))>max(X((div+1):length(X))))
        display('Cluster overlap...');
        OS.expr=t;
        OS.X=X;
        OS.Y=Y;
        OS.range=[0 0];
    else
        OS1=clusterFit(X(1:div),Y(1:div),model,sseThresh,nderivs,gof.sse);
        OS2=clusterFit(X((div+1):length(X)),Y((div+1):length(Y)),model,sseThresh,nderivs,gof.sse);
        if (isempty(OS1)||isempty(OS2))
            display('Cluster failed...');
            OS.expr=t;
            OS.X=X;
            OS.Y=Y;
            OS.range=[0 0];
        else
            OS=[OS1 ; OS2];
        end
    end
else
    OS.expr=t;
    OS.X=X;
    OS.Y=Y;
    OS.range=[0 0];
end
if (nargin<6)
    plot(X,Y,'b:');
    hold on;
    for i=1:length(OS)
        plot(OS(i).X,OS(i).expr(OS(i).X),'r-');
        if (i==1)
            OS(i).range(1)=min(OS(i).X);
        else
            OS(i).range(1)=(min(OS(i).X)+max(OS(i-1).X))/2;
        end
        if (i==length(OS))
            OS(i).range(2)=max(OS(i).X);
        else
            OS(i).range(2)=(max(OS(i).X)+min(OS(i+1).X))/2;
        end
    end
    hold off;
end