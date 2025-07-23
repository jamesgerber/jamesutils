function c=ExpandStructure(a,b)
% MERGESTRUCTURE - merge all fields in two distinct structure
%
%

c=a;

names=fieldnames(b);
for j=1:length(names);

        c=setfield(c,names{j},getfield(b,names{j}));
        
end


