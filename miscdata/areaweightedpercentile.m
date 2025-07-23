function x=AreaWeightedPercentile(area,data,p);
%AreaWeightedPercentile - calculate a percentile value by area
%
%  SYNTAX
%    PercentileValue=AreaWeightedPercentile(Area,Data,p);
%  
%  EXAMPLE
%    AreaWeightedPercentile(fma,testdata,50)
%

if ~isequal(size(area),size(data))
    error('unequal vector sizes');
end

if max(area)<2
   % warning(['This appears to be area fraction'])
end   

if p>=1
    error([' this code uses fractional percent '])
end

iigood=isfinite(data) & isfinite(area);

data=data(iigood);
area=area(iigood);


[dum,ii]=sort(data);

sortedarea=area(ii);
sorteddata=data(ii);

tmp=cumsum(sortedarea);
normcumarea=tmp/max(tmp);

%find the value 
[dum,j]=min( (normcumarea-p).^2);

x=sorteddata(j);


%if ~isfinite(x)
%    warning(['non-finite value here in ' mfilename])
%end
