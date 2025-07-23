function NewMatrix=ResampleGrid(OldMatrix,N);
% ResampleGrid - Resample Grid DATA TO A FINER RESOLUTION GRID
%
%      SYNTAX:
%       NewMatrix=ResampleGrid(OldMatrix,N) will produce a new matrix
%       NewMatrix which is comprised of NxN blocks of each of the
%       values of OldMatrix
%
%     example
%
%      new=ResampleGrid(y,2160/360)

if nargin==1
  N=2;
end

[R,C]=size(OldMatrix);

NR=R*N; %Num Rows
NC=C*N; %Num Cols

ii=1:N:(NR+1-N);
jj=1:N:(NC+1-N);

for j=1:N
  for m=1:N
  NewMatrix(ii+(j-1),jj+(m-1))=OldMatrix;
  end
end



