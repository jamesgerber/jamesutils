function v=nearestNonZero(r,c,G)
for (l=0:length(G))
    tmp=nonzeros(G(max([r-l,1]):min([r+l,size(G,1)]),max([c-l,1]):min([c+l,size(G,2)])));
    if ~isempty(tmp)
        v=tmp(1);
        break;
    end
end
end