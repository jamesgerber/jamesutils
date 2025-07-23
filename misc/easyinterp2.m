function B=EasyInterp2(A,rows,cols,method)
% EasyInterp2 - interpolate 2-dimensional matrix with easy syntax
%
% SYNTAX
%     B=EasyInterp2(A,n); B is A expanded to n times original size
%
%     B=EasyInterp2(A,n,method); B is A expanded to n times original size
%     using method
%   
%     B=EasyInterp2(A,rows,cols); B is A stretched to size rows x cols
%
%     B=EasyInterp2(A,rows,cols, method); B is A stretched to size rows x
%     cols using method
%
%     B=EasyInterp2(A); B is A stretched to size 4320x2160
%
%     EasyInterp2 is designed to make interp2, the built in 2-d matrix
%     interpolation function, more accessible. It can be used to stretch a
%     small data set to a greater size if needed, or a vice versa, and
%     will return the entered matrix exactly as-was if its dimensions match
%     rows x cols. Without this function, imresize is the easiest way to do
%     this.
%
% EXAMPLE
% B=EasyInterp2(magic(5,5),4320,2160,'linear');
%

if (nargin==1)
    rows=4320;
    cols=2160;
end
if nargin<4
    method='nearest';
end
if nargin==2
    cols=round(size(A,2)*rows);
    rows=round(size(A,1)*rows);
else
    if ischar(cols)
        method=cols;
        cols=round(size(A,2)*rows);
        rows=round(size(A,1)*rows);
    end
end
R=(1:(size(A,2)-1)/(cols-1):size(A,2));
C=(1:(size(A,1)-1)/(rows-1):size(A,1));
rows=0;
cols=0;
B=interp2(A,R,rot90(C,3),method);
R=0;
C=0;