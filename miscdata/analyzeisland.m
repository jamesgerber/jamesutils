function [rv,cv,area,edge]=analyzeisland(r,c,A)
% [rv,cv,area,edge]=analyzeisland(r,c,A) - find the row and col indices,
% area, and perimeter of the contiguous region surrounding a point in an
% array
%
% SYNTAX
% [rv,cv,area,edge]=analyzeisland(r,c,A) returns rv and cv as row and col
% indices vectors, area as the number of points in the contiguous region,
% and edge as the length of the perimeter.
%
% recursion is technically avoided thanks to use of integer vectors to save
% a list of what would otherwise be recursive commands; this means that it
% can run on any size array when otherwise MATLAB would have a recursion
% depth limit error
%
% EXAMPLE
% A=rand(9,9);
% A=floor(A*3);
% [rv,cv,area,edge]=analyzeisland(5,5,A);

core=A(r,c);
check=zeros(size(A));
edge=0;
commandr=r;
commandc=c;
rv=[];
cv=[];
while ~isempty(commandr)
    r2=commandr(1);
    c2=commandc(1);
    if (~(r2<1||c2<1||r2>size(A,1)||c2>size(A,2))&&A(r2,c2)==core)
        if (check(r2,c2)==0)
            check(r2,c2)=1;
            rv(length(rv)+1)=r2;
            cv(length(cv)+1)=c2;
            commandr((length(commandr)+1):(length(commandr)+4))=[r2-1,r2,r2+1,r2];
            commandc((length(commandc)+1):(length(commandc)+4))=[c2,c2-1,c2,c2+1];
        end
    else edge=edge+1;
    end
    commandr=commandr(2:length(commandr));
    commandc=commandc(2:length(commandc));
end
area=length(rv);