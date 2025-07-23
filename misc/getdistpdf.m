function OS=getDistPDF(data,model,sseThresh,nderivs)
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
figure;
for i=1:length(OS)
cf=OS(i,1).expr;
s=sym(formula(cf));
cn=coeffnames(cf);
cv=coeffvalues(cf);
for j=1:length(cv)
    s=subs(s,cn{j},cv(j));
end

OS(i,1).PDFexpr=diff(finverse(s));
OS(i,1).PDFrange(1)=min(OS(i,1).Y);
OS(i,1).PDFrange(2)=max(OS(i,1).Y);
if (i>1)
    OS(i,1).PDFrange(1)=(OS(i-1,1).PDFrange(2)+OS(i,1).PDFrange(1))/2;
    OS(i-1,1).PDFrange(2)=OS(i,1).PDFrange(1);
end
end


for i=1:length(OS)
plot([OS(i,1).PDFrange(1):.01:OS(i,1).PDFrange(2)],...
    subs(OS(i,1).PDFexpr,[OS(i,1).PDFrange(1):.01:OS(i,1).PDFrange(2)]),'b-')
hold on;
end