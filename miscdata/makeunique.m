function A=makeunique(data)
% MAKEUNIQUE - set each "data island" in data to a unique identifier
%
% SYNTAX
% A=makeunique(data) returns array A of size data with each unique contiguous region set to a unique value
%
% EXAMPLE
% A=makeunique(floor(rand(A)*3));
%

A=zeros(size(data));
A(isnan(data))=nan;
i=1;
while ~isempty(find(A==0,1))
    display([num2str(length(find(A==0))) '/' num2str(size(data,1)*size(data,2)) ', ' num2str(i)]);
    [r c]=find(A==0);
    [r c]=analyzeisland(r(1),c(1),data);
    inds=sub2ind(size(data),r,c);
    A(inds)=i;
    i=i+1;
end
end