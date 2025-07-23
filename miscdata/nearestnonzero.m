function [v,i]=nearestnonzero(r,c,G)
% NEARESTNONZERO - return the value of the nearest nonzero element to index r,c
%
% SYNTAX
% v=nearestNonZero(r,c,G) - return the value of the closest nonzero element
% in G to r,c, as determined by expanding a square from r,c and stopping as
% soon as a nonzero element is within the square.  If two or more appear in
% the square at once, the one that has the lowest linear index - ie the one
% that is furthest left and, if >1 are in the same column, the one in that
% column that is closer to the top - will be returned.
%
% EXAMPLE
% G=magic(5);
% G=G.*(G>20);
% v=nearestNonZero(1,1,G);
for (l=0:length(G))
    tmp=nonzeros(G(max([r-l,1]):min([r+l,size(G,1)]),max([c-l,1]):min([c+l,size(G,2)])));
    if ~isempty(tmp)
        v=tmp(1);
        break;
    end
end
end