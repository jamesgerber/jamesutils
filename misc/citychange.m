function [NewLong,NewLat]=CityChange(OldLong,OldLat,OldGDD,OldPrec,NewGDD, ...
			    NewPrec);
%function CityChange - determine location (lat/long) of a point
%with equivalent climate characteristics


[Long,Lat]=inferlonglat(OldGDD);

[dum,iiRow]=min( abs(Long-OldLong));
[dum,iiCol]=min( abs(Lat-OldLat));


% now find long/lat of point with closest Prec, GDD
OldPrecValue=OldPrec(iiRow,iiCol);
OldGDDValue=OldGDD(iiRow,iiCol);

[LatMat,LongMat]=meshgrid(Lat,Long);



[MinVal,RowIndex,ColumnIndex]=...
    min2d( (NewPrec-OldPrecValue).^2/OldPrecValue.^2+... 
           (NewGDD-OldGDDValue).^2/OldGDDValue.^2 + ...
	   (LongMat-OldLong).^2/50^2 + ...
	   (LatMat-OldLat).^2/100 ^2);

NewLong=Long(RowIndex);
NewLat=Lat(ColumnIndex);
				     
