function IDS=averagefieldsofvectorofstructures(IDSStruct);
% oops - not 

fn=fieldnames(IDSStruct(1));



N=numel(IDSStruct);

for j=1:numel(fn);
    field=fn{j};

    for n=1:N
    
    I=IDSStruct(n);
    if n==1;
        xnew=I.(field);
    else
        xnew=xnew+I.(field);
    end

    end

    IDS.(field)=xnew/N;
end