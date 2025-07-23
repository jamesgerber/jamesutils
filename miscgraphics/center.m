function [r,c]=center(A,val,squeeze,ri,ci,breadth,depth)
% CENTER - find the center of a cluster of values near val in array A.
% Designed as helper function for tracer.
%
% SYNTAX
% [r,c]=center(A,val,squeeze,ri,ci,breadth,depth) sets [r,c] to the indices
% of the center of the cluster.  A is the array, val is the value to look
% for, squeeze is the degree of tolerance of variation (the higher, the
% more tolerant), ri and ci are indices that the cluster should be near,
% breadth is the vertical and horizontal breadth to look in, and depth is
% the number of recursions to allow in the search (the higher, the more
% precise)
% All arguments except A and val are optional; for an argument to be
% specified, all arguments to its left must also be specified.

if nargin<7
    depth=1;
end
if nargin<3
    squeeze=0;
end
for i=1:depth
    sqerror=((A-val).^2+squeeze).^-1;
    
    rweights=zeros(size(A));
    for c=1:size(A,2)
        rweights(:,c)=1:size(A,1);
    end
    
    cweights=zeros(size(A));
    for r=1:size(A,1)
        cweights(r,:)=1:size(A,2);
    end
    
    if (nargin>=6)
        sqerror=sqerror.*(abs(ri-rweights)<breadth);
        sqerror=sqerror.*(abs(ci-cweights)<breadth);
    end
    
    rweights=rweights.*sqerror;
    cweights=cweights.*sqerror;
    ri=sum(sum(rweights))./sum(sum(sqerror));
    ci=sum(sum(cweights))./sum(sum(sqerror));
end
r=ri;
c=ci;