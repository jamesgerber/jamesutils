function p=invcdf(x,cdist,y)
% invcdf - calculate the inverse of a cdf function
%
%  syntax
%     p=invcdf(x,cdist,y) where x,cdist are the cumulative distribution
%     function, y is an array of values between 0 and 1, and p will be a
%     set of inverse cdf values of the same size as y
%
%  EXAMPLE
%     data=cumprod(rand(1,10))
%     dist=cdf('exp',data,mean(data))
%     p=invcdf(.1:.1:1,dist,data)

if max(max(max(y)))>max(cdist)
    error('max value of y > max(cdist)')
end

if min(min(min(y)))<min(cdist)
    warning('min value of y < min(cdist)')
    y(y<min(cdist))=min(cdist);
end  

if length(x)<20
    warning('not very many points here.')
end

N=1000;
xaxis=linspace(min(x),max(x),N);
cinterp=interp1(x,cdist,xaxis,'nearest');
yaxis=linspace(min(cdist),max(cdist),N);


p=-999*zeros(size(y)); %initialize p or that loop will be too slow

%here is a loop that could probably be vectorized ...
for j=1:numel(y)
    % which value of cdf corresponds to this input value?
    ii=closest(cinterp,y(j));
    % find x-axis correlate for that guy
    p(j)=xaxis(ii);
end

return


