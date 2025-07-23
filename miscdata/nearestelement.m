function [a,i]=nearestelement(A,x)
% NEARESTELEMENT - return the nearest element to x of matrix A
%
% SYNTAX
% [a,i]=nearestelement(A,x) - sets a to the vector of the values nearest x
% in every column of A, or the value nearest x if A is a vector.  Sets i to
% the indices of a.
%
% EXAMPLE
% A=rand(5)
% [a,i]=nearestelement(A,.5)
[~,i]=min(abs(A-x));
a=A(i);