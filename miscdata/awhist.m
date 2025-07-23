function [S]=awhist(val,weight,edges);
%  awhist - area weighted histogram
%  [S]=awhist(val,weight,edges);
%
%   distbyoccurence,distbyweight,distbyweightedval,iibin
%
% Example:
%
% val=1:100;
% weight=sqrt(1:100);
% 
%  total production = sum(val.*weight)
%  approximately equal to sum(S.distbyweight.*S.bincenters)
%  approximately equal to sum(S.distbyweightedval)
%
% S=awhist(val,weight,[0:10:100])
% 

if numel(edges)==1
    N=100;
    del=(max(val)-min(val))/2;
    edges=linspace(min(val)-del/2,max(val)+del/2,N+1);
end



iibin=val*0+weight*0;   % lazy way to initialize this and check that val and weight are same size


for j=1:length(edges)-1;
    
    ii=val >=edges(j) & val < edges(j+1);
    
    distbyoccurence(j)=length(find(ii));
    distbyweight(j)=sum(weight(ii));
    distbyweightedval(j)=sum(val(ii).*weight(ii));
    iibin(ii)=j;
end


bincenters=(edges(1:end-1) + edges(2:end)) /2;

S.distbyoccurence=distbyoccurence;
S.distbyweight=distbyweight;
S.distbyweightedval=distbyweightedval;
S.iibin=iibin;
S.bincenters=bincenters;