function colorvals=ScaleColors(scale,cvector)
% ScaleColors - replace values scaled 0-1 with a uint8 color vals (0-255)
%
% SYNTAX:
%          colorvals=ScaleColors(scale,cvector);
%
%  See Also MakeGlobalOverlay

scale(scale>1)=1;
scale(scale<0)=0;
scale(isnan(scale))=0;


N=numel(cvector);
iiColor=1:N;
IndexArray=1+floor(scale*(N-1));
a=cvector(IndexArray);
colorvals=uint8(a*255);
