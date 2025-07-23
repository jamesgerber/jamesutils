 function [ii,indices]=FindAny(X,Matches);
 %FINDANY - look for any matches in a vector. 
 %         [II,INDICES]=FindAny(X,Matches) returns those indices INDICES of vector x which 
 %         are equal to any of the elements in Matches.  II contains a logical vector 
 %         corresponding to elements of X.  (INDICES=find(II));
 %
 %   Example
 %
 %   FindAny(1:10,[2 4 9]);
%
% 
 ii=zeros(size(X));
 for j=1:length(Matches);
     ii=(ii | X==Matches(j));
 end
 indices=find(ii);
