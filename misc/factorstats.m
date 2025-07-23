function [min,mindist]=factorstats(A)
mindist=999999999;
min=[];
for i=1:size(A,1)-1
    for j=i+1:size(A,1)
        tmp=factordist(A(i,1:size(A,2)),A(j,1:size(A,2)));
        if (tmp<mindist)
            mindist=tmp;
            min=[i j];
        end
    end
end
