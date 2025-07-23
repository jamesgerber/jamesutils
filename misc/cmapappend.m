function [NewMap,coeff,offset]=CMapAppend(A,B,min1,max1,min2,max2)
% CMAPAPPEND - helper function to CategorySelectMap
NewMap=zeros(size(A,1)+size(B,1),3);
NewMap(1:size(A,1),:)=A;
NewMap(size(A,1)+1:end,:)=B;
zero2=-min2/(max2-min2)*(size(B,1)-1)+1;
zero1=-min1/(max1-min1)*(size(A,1)-1)+1;
offset=(zero2+size(A,1)-zero1)*(max1-min1)/size(A,1);
coeff=((max1-min1)/(size(A,1)-1))/((max2-min2)/(size(B,1)-1));