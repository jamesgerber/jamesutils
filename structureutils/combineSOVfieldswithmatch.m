function NS=combineSOVfieldswithmatch(a,valuefield,combinefield,combineelements,matchfields);
% combineSOVfieldswithmatch - combine values
%
%  This is useful when a structure has emissions values which need to be
%  added together, but need to confirm that other fields match.  Example
%  would be a food balance sheet structure of vectors and you want to add
%  milk to eggs ... this would give you the sum of them, and would make
%  sure that the geographic area field matched up.  (the way it's written
%  now it won't sort to confirm them, just checks that they do)
%


for j=1:numel(combineelements)
    ii=strcmp(a.(combinefield),combineelements{j});
    ES(j).value=a.(valuefield)(ii);
    ES(j).idx=find(ii);
    ES(j).fieldname=combineelements{j};
end

% now combine ... assume structure perfectly ordered, just check

NS.newvalue=ES(1).value+ES(2).value+ES(3).value;


for m=1:numel(matchfields);
    for j=2:3
        idx1=ES(1).idx;
        idxj=ES(j).idx;
        if ~isequal(a.(matchfields{m})(idx1),a.(matchfields{m})(idxj))
            error
        end
    end

    NS.(matchfields{m})=a.(matchfields{m})(ES(1).idx);
end

