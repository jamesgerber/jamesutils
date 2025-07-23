function [MinVal,RowIndex,ColumnIndex]=min2d(z)
% MIN2D - returns min value of 2d matrix, and index
%
%  Can return either row/column indices or a single matrix index depending
%  on the output syntax
%
%  SYNTAX
%         [MinVal,RowIndex,ColumnIndex]=min2d(z);
%         [MinVal,MatrixIndex]=min2d(z);
%
%  example
%
%          z=rand(5,12);
%          z(3,4)=2.7;
%          [MinVal,RowIndex,ColumnIndex]=min2d(z)
%          z(RowIndex,ColumnIndex)
%
%          z(3,4)=2.7;
%          [MinVal,MatrixIndex]=min2d(z)
%          z(MatrixIndex)
%

%  J. Gerber
%  Global Landscapes Initiative
%  University of Minnesota


switch nargout
    case {0,1}
        
        minval=min(z(:));
    case 2
        [minval,RowIndex]=min(z(:));
        % RowIndex doesn't actually equal row index here - it's a matrix
        % index
    case 3
    
    [mincolval,colindex]=min(z);
    [minval,rowindex]=min(mincolval);
  
    RowIndex=colindex(rowindex);
    ColumnIndex=rowindex;
end