function A=testdata(r,c,structflag)
% TESTDATA - provide randomly generated test data
%
% SYNTAX
% A=testdata - set A to a randomly generated 4320x2160 array
% A=testdata(r,c) - set A to a randomly generated r x c array
% A=testdata(r,c,1) - set A to a structure containing test data and
% lat/long indices
%
% EXAMPLE
% A=testdata

if nargin==0
    r=4320;
    c=2160;
end
A=rand(5);
A(6,:)=A(1,:);
if ((nargin==3)&&(structflag==1))
    Data=EasyInterp2(A,r+1,c,'linear');
    [long,lat]=InferLongLat(Data);
    A.Data=Data;
    A.Long=long;
    A.Lat=lat;
    A.RandomVector=rand(1,10);
else
    A=EasyInterp2(A,r+1,c,'linear');
end
A=A(1:r,:);