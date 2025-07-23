function highresdata=disaggregate_rate(loresdata,N);
% disaggregate - spread data/ha out to a smaller resolution
%
%  Syntax
%     highresdata=disaggregate_rate(loresdata,N);
%
%  Example
%     hda=GetHalfDegreeGridCellAreas;
%     halfdegreearea=disaggregate_rate(hda,6);
%
%     See also:  disaggregate_quantity

[r,c]=size(loresdata);


if min(r,c)==1
    disp(['vector - assuming an x or y coordinate, smoothing out']);


    delL=mean(diff(loresdata));
    dell=delL/N;
    
    l1=loresdata(1)-(N-1)/2*dell;
    
    lM=loresdata(end)+(N-1)/2*dell;


    highresdata=l1:dell:(lM+dell*.001);   % push a bit to the end so roundoff error doesn't screw things up.
    
    

else
    
    
    highresdata(r*N,c*N)=0;
    for j=1:N
        for m=1:N
            highresdata(j:N:(N*r),m:N:(N*c))=loresdata;
        end
    end
end