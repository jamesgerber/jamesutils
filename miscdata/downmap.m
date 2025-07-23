function varargout=DownMap(Long,Lat,Data)
% DownMap - resample data by 1:4, maintaining mean,max,min,mean square
%
%  SYNTAX
%
%     [RedLong,RedLat,RedData]=DownMap(Long,Lat,Data);
%        where Long = longitude vector
%              Late = latitude vector
%              Data = data matrix
%      will result in
%               RedData = reduced data set containing 1/4
%        as many elements as Data.
%               RedLong = reduced length Longitude Vector
%               RedLat  = reduced length Latitude Vector
%
%     [RedLong,RedLat,RedData]=DownMap(Data);  Will assume that
%     Data is a global surface dataset, and will calculate Long and
%     Lat appropriately
%
%     RedData has the property that it has approximately 1/4 as
%     many elements as Data.  (approximate because Data may not be
%     a (4m x 4n) matrix)
%
%     RedData is constructed of 2x2 matrices which are reduced from
%     4x4 matrices within Data.   
%
%  so this 4 x 4 matrix:
%     W W X X  
%     W W X X  
%     Y Y Z Z  
%     Y Y Z Z  
%
% is mapped to this 2 x 2 matrix:
%      w   x
%      y   z
%
%   where w=min(W W), x = min (X X),  y=min(Y Y),    z=min(Z Z)
%              (W W)          (X X)        (Y Y)          (Z Z)
%
%  Then, the global maximum of the 4x4 matrix is used to overwrite one of
%  the w x y or z values depending on the quadrant where the global maximum
%  was located.  This is also then done with the global minimum.



%     Note that it is not possible to choose the four values so that
%     maximum and minimum are reproduced and the mean is reproduced
%     Consider the data set
%     Data=
%     [0 0 0 16
%      0 0 0 0
%      0 0 0 0
%      0 0 0 0]
%     To have maximum and minimum and retain the same mean, it would be
%     necessary to do something like this:
%     ReducedData=
%      [0 16
%       -6 -6]
%      This has the same maximum, mean as Data, but the minimum is now -6
%      instead of 0.    However, this is terrible with categorical
%      data.   Even with non-categorical data, it does awful things near,
%      say, a lake.
%
%      It is possible to put in the maximum, minimum, and the actual mean 
%      value from the original data [different from above because there is
%      no attempt to keep the mean of the dataset constant].  Here that
%      would result in:
%      [0 16
%       1  1]    
%      This is also unpleasant with categorical data
%
%       I think the best would be to but in the modal value.  However, I
%       ahve found no fast way to calculate a modal value.  If this code
%       takes 30 seconds to run, it isn't terribly useful ...
%
%      a possible change would be to put in code to see if the data seems 
%      categorical.   If so, then use max/min/max/min (as above) otherwise
%      use max/mean/mean/min.  This should be implemented in conjunction
%      with something smart near the land/ocean interface so that we don't
%      average out to half-values...
%
%     JSG  August 28, 2009
%     IonE


if nargin==0
    help(mfilename);
    return
end


if nargin==1
  % first argin is Data
  Data=Long;
  [Long,Lat]=InferLongLat(Data);

end

RedLat=Lat(2:2:end);
RedLong=Long(2:2:end);

[Nrow,Ncol]=size(Data);
NrowRed=Nrow/2;
NcolRed=Ncol/2;

[MatrixToOrderedRow,MatrixToOrderedRowReduced]=MakeIndexArrays(Nrow,Ncol);

MatrixData=Data;
RowData=Data(MatrixToOrderedRow);


Data=RowData;

ii=1:16:(Nrow*Ncol);



RDMax=max(max(max(max(max(max(max(max(...
    max(max(max(max(max(max(max(...
    Data(ii),...
    Data(ii+1)),...
    Data(ii+2)),...
    Data(ii+3)),...
    Data(ii+4)),...
    Data(ii+5)),...
    Data(ii+6)),...
    Data(ii+7)),...
    Data(ii+8)),...
    Data(ii+9)),...
    Data(ii+10)),...
    Data(ii+11)),...
    Data(ii+12)),...
    Data(ii+13)),...
    Data(ii+14)),+...
    Data(ii+15));


RDMin=min(min(min(min(min(min(min(min(...
    min(min(min(min(min(min(min(...
    Data(ii),...
    Data(ii+1)),...
    Data(ii+2)),...
    Data(ii+3)),...
    Data(ii+4)),...
    Data(ii+5)),...
    Data(ii+6)),...
    Data(ii+7)),...
    Data(ii+8)),...
    Data(ii+9)),...
    Data(ii+10)),...
    Data(ii+11)),...
    Data(ii+12)),...
    Data(ii+13)),...
    Data(ii+14)),+...
    Data(ii+15));

% % % RDMean=(Data(ii)+...
% % %     Data(ii+1)+...
% % %     Data(ii+2)+...
% % %     Data(ii+3)+...
% % %     Data(ii+4)+...
% % %     Data(ii+5)+...
% % %     Data(ii+6)+...
% % %     Data(ii+7)+...
% % %     Data(ii+8)+...
% % %     Data(ii+9)+...
% % %     Data(ii+10)+...
% % %     Data(ii+11)+...
% % %     Data(ii+12)+...
% % %     Data(ii+13)+...
% % %     Data(ii+14)+...
% % %     Data(ii+15))/16;



%%% now want to figure out what quadrant all of the maxima are in.

UpperLeftMaxima=max(max(max(    Data(ii),...
    Data(ii+1)),...
    Data(ii+5)),...
    Data(ii+6));
UpperLeftIsMaximumLogical=((UpperLeftMaxima-RDMax)==0);

UpperRightMaxima=max(max(max(    Data(ii+9),...
    Data(ii+10)),...
    Data(ii+13)),...
    Data(ii+14));
UpperRightIsMaximumLogical=((UpperRightMaxima-RDMax)==0);

LowerLeftMaxima=max(max(max(    Data(ii+2),...
    Data(ii+3)),...
    Data(ii+6)),...
    Data(ii+7));
LowerLeftIsMaximumLogical=((LowerLeftMaxima-RDMax)==0);

LowerRightMaxima=max(max(max(    Data(ii+10),...
    Data(ii+11)),...
    Data(ii+14)),...
    Data(ii+15));
LowerRightIsMaximumLogical=((LowerRightMaxima-RDMax)==0);



%%% SAME THING FOR MINIMA.

UpperLeftMinima=min(min(min(    Data(ii),...
    Data(ii+1)),...
    Data(ii+5)),...
    Data(ii+6));
UpperLeftIsMinimumLogical=((UpperLeftMinima-RDMin)==0);

UpperRightMinima=min(min(min(    Data(ii+9),...
    Data(ii+10)),...
    Data(ii+13)),...
    Data(ii+14));
UpperRightIsMinimumLogical=((UpperRightMinima-RDMin)==0);

LowerLeftMinima=min(min(min(    Data(ii+2),...
    Data(ii+3)),...
    Data(ii+6)),...
    Data(ii+7));
LowerLeftIsMinimumLogical=((LowerLeftMinima-RDMin)==0);

LowerRightMinima=min(min(min(    Data(ii+10),...
    Data(ii+11)),...
    Data(ii+14)),...
    Data(ii+15));
LowerRightIsMinimumLogical=((LowerRightMinima-RDMin)==0);



%% right ... now I know where the maxima and minima are.

% Construct a ReducedDataRow with the minima set with

NumManipulations=Nrow*Ncol/16;
ii=1:4:(4*NumManipulations);
ReducedDataRow(ii)=UpperLeftMinima;
ReducedDataRow(ii+1)=LowerLeftMinima;
ReducedDataRow(ii+2)=UpperRightMinima;
ReducedDataRow(ii+3)=UpperLeftMinima;



% now replace with the maximum value

jj=find(UpperLeftIsMaximumLogical);
ReducedDataRow(ii(jj))=RDMax(jj);

jj=find(LowerLeftIsMaximumLogical);
ReducedDataRow(ii(jj)+1)=RDMax(jj);

jj=find(UpperRightIsMaximumLogical);
ReducedDataRow(ii(jj)+2)=RDMax(jj);

jj=find(LowerRightIsMaximumLogical);
ReducedDataRow(ii(jj)+3)=RDMax(jj);


% now replace with the minimum value

jj=find(UpperLeftIsMinimumLogical);
ReducedDataRow(ii(jj))=RDMin(jj);

jj=find(LowerLeftIsMinimumLogical);
ReducedDataRow(ii(jj)+1)=RDMin(jj);

jj=find(UpperRightIsMinimumLogical);
ReducedDataRow(ii(jj)+2)=RDMin(jj);

jj=find(LowerRightIsMinimumLogical);
ReducedDataRow(ii(jj)+3)=RDMin(jj);


ReducedData=-1*ones(length(RedLong),length(RedLat));

ReducedData(MatrixToOrderedRowReduced)=ReducedDataRow;



if nargout==1
    varargout{1}=ReducedData;
end

if nargout==3
    varargout{3}=ReducedData;
    varargout{1}=RedLong;
    varargout{2}=RedLat;
end


%%%%%%%%%%%%%%%%%%%%%%%%%
%   MakeIndexArrays     %
%%%%%%%%%%%%%%%%%%%%%%%%%
function [MatrixToOrderedRow,MatrixToOrderedRowReduced]=MakeIndexArrays(Nrow,Ncol);

legacy=0;
if legacy==1
    ii=[1:4  (1:4)+Nrow (1:4)+Nrow*2 (1:4)+Nrow*3];
    
    jj=[];
    for j=1:(Nrow/4);
        jj=[jj ii+4*(j-1)];
    end
    
    kk=[];
    for j=1:Ncol/4;
        kk=[kk jj+Nrow*4*(j-1)];
    end
    
    MatrixToOrderedRow=kk;
    
    %%% now small version
    ii=[1:2  (1:2)+Nrow/2];
    
    jj=[];
    for j=1:(Nrow/4);
        jj=[jj ii+2*(j-1)];
    end
    
    kk=[];
    for j=1:Ncol/4;
        kk=[kk jj+Nrow*(j-1)];
    end
    
    MatrixToOrderedRowReduced=kk;
else
    ii=[1:4  (1:4)+Nrow (1:4)+Nrow*2 (1:4)+Nrow*3];
    
    jj=-1*ones(1,Nrow*4);
    for j=1:(Nrow/4);
        jj((1:16)+(j-1)*16)=[ii+4*(j-1)];
    end
    
    kk=-1*ones(1,Nrow*Ncol);
    
    N=length(jj);
    
    for j=1:Ncol/4;
        kk( (1:N)+ (j-1)*N)=jj+Nrow*4*(j-1);
    end
    
    MatrixToOrderedRow=kk;
    
    %%% now small version
    ii=[1:2  (1:2)+Nrow/2];
    
    jj=[];
    for j=1:(Nrow/4);
        jj=[jj ii+2*(j-1)];
    end
    
    kk=-1*ones(1,Nrow*Ncol/4);;
    for j=1:Ncol/4;
        kk( (1:length(jj))+ (j-1)*length(jj))=[jj+Nrow*(j-1)];
    end
    
    MatrixToOrderedRowReduced=kk;
end

