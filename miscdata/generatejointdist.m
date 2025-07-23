function [jp,xbins,ybins,XBinEdges,YBinEdges]=GenerateJointDist(X,Y,XBinEdges,YBinEdges,Weight)
% GENERATEJOINTDIST - Generate joint distribution of two vectors
%
%  [jp,xbins,ybins]=GenerateJointDist(X,Y,XBinEdges,YBinEdges,Weight);
%
%
%  Syntax Notes:
%
%      X and Y must be vectors of equal length
%      XBinEdges (and YBinEdges) may be given as a number N.  If this is
%      the case, then the hist command will be used to determine N equally
%      spaced bins.
%
%      jp is the joint probability distribution
%      xbins is a vector denoting the centers of the bins.  so
%      length(xbins)=length(XBinEdges)-1 
%
%  EXAMPLE
%      [jp,xbins,ybins,XBinEdges,YBinEdges]=GenerateJointDist(rand(1,30),rand(1,30),5,5)
%
%
%   See Also:  SelectUniformBins
%
%
%    Be careful with square JPD's !!!!!
%
%   Always a good idea to make s

 
if nargin==0
    help(mfilename)
    return
end

if nargin==2
    XBinEdges=10;
    YBinEdges=10;
end

if nargin<5
    Weight=ones(size(X));
end


if length(XBinEdges)==1
  [N,XBinEdges]=histcounts(X,XBinEdges);
  XBinEdges(end+1)=XBinEdges(end)+ (XBinEdges(end)-XBinEdges(end-1));
end

if length(YBinEdges)==1
  [N,YBinEdges]=histcounts(Y,YBinEdges);
  YBinEdges(end+1)=YBinEdges(end)+ (YBinEdges(end)-YBinEdges(end-1));
end


NX=length(XBinEdges)-1;
NY=length(YBinEdges)-1;

for j=1:NX;
   ii=find( X>(XBinEdges(j)) & X<=(XBinEdges(j+1)));
   [N]=histc(Y(ii),YBinEdges);  %want a column vector 
   % note that N is length NY+1.  This is due to the way that histc works
   % it will always end in 0 if there are no points on the final bin edge
   % vector.  it's bec you're specifying, for example, 11 numbers for 10
   % bins.     
   
   
   jp(j,1:NY)=N(1:end-1);  %This is the non-weighted version
   
   % now the weighty part.
   Wx=Weight(ii);  %Wx is the weight to be associated with this particular slice in X.
   %now we have to figure out how to partition in Y.
   Yslice=Y(ii);
   
   % need to rework the bins
   for m=1:length(YBinEdges)-1
       kk=find( Yslice>(YBinEdges(m)) & Yslice<=(YBinEdges(m+1)));
       N(m)=length(kk);
       WeightedN(m)=sum(Wx(kk));
   end
   N(end+1)=0;   %to give a length consistent with histc output
   N=N(:);
   WeightedN(end+1)=0;
   WeightedN=WeightedN(:);
   % sanity check:  This N should equal the N from the histc(Y) command.
   % It does.  
   
   jpweighted(j,1:NY)=WeightedN(1:end-1);  %This is the non-weighted version
   clear WeightedN N
end

jp=jpweighted;


xbins=(XBinEdges(1:end-1)+XBinEdges(2:end))/2;
ybins=(YBinEdges(1:end-1)+YBinEdges(2:end))/2;


if nargout==0
    figure
    set(gcf,'renderer','zbuffer')
    cs=surface(xbins,ybins,jpweighted.');
    colorbar
    title('Joint distribution')
    shading flat
end
