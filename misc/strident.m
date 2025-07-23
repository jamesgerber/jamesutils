function a=strident(str)
% strident - create a unique number for the given string
%
% SYNTAX
% a=strident(str) sets a to a positive integer unique to string str
%
% EXAMPLE
% a=strident('USA');

a=0;
for i=1:length(str)
    a=a+(128^(i-1))*sum(str(i));
end
