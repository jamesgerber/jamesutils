function d=factordist(A,B)
sum=0.0;
for i=1:length(A)
    sum=sum+(A(i)-B(i))^2;
end
d=sqrt(sum);