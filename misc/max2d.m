function [maxval,RowIndex,ColumnIndex]=max2d(z)
% MAX2D - returns max value of 2d matrix, and index
%
%  Can return either row/column indices or a single matrix index depending
%  on the output syntax
%
%  SYNTAX
%         [MaxVal,RowIndex,ColumnIndex]=max2d(z);
%         [MaxVal,MatrixIndex]=max2d(z);
%
%  example
%
%          z=rand(5,12);
%          z(3,4)=2.7;
%          [MaxVal,RowIndex,ColumnIndex]=max2d(z)
%          z(RowIndex,ColumnIndex)
%
%          z(3,4)=2.7;
%          [MaxVal,MatrixIndex]=max2d(z)
%          z(MatrixIndex)
%

%  J. Gerber
%  Global Landscapes Initiative
%  University of Minnesota


switch nargout
    case {0,1}
        
        maxval=max(z(:));
    case 2
        [maxval,RowIndex]=max(z(:));
        % RowIndex doesn't actually equal row index here - it's a matrix
        % index
    case 3
    
    [maxcolval,colindex]=max(z);
    [maxval,rowindex]=max(maxcolval);
  
    RowIndex=colindex(rowindex);
    ColumnIndex=rowindex;
end
    