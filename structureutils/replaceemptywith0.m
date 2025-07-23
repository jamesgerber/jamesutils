function os=replaceemptywith0(is);
% replaceemptywith0 replace empty fields of a structure with zero
a=fieldnames(is);

for j=1:numel(a)
    
    thisfield=is.(a{j});
    
    if isstruct(thisfield)
        % recursive call
        is.(a{j})=replaceemptywith0(is.(a{j}));
    elseif isempty(thisfield)
        is.(a{j})=0;
    elseif isnan(thisfield)
        is.(a{j})=0;
    end
    
end

os=is;
