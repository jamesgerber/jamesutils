function S=latlongxytoarea(X,Y);
% calculate some from a polygon

T.X=X;
T.Y=Y;
T.dummy=logical(1);

[Long,Lat,R]=ShapeFileToRaster(T,'dummy');

[Long,Lat,Long2,Lat2]=InferLongLat(R);

Rlogical=logical(R);

S.LatCentroid=sum(Lat2(Rlogical).*fma(Rlogical))./sum(fma(Rlogical));
S.LonCentroid=sum(Long2(Rlogical).*fma(Rlogical))./sum(fma(Rlogical));
S.area=sum(fma(Rlogical));
S.logicalinclude=Rlogical;