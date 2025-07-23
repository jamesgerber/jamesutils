% DETREND Remove a linear trend from a vector, usually for FFT processing,
%          for data with NaN's (this routine ignores NaN's).  NOTE:  this
%          routine assumes evenly spaced data
% 
%    Y = DETREND(X) removes the best straight-line fit linear trend from 
%    the data in vector X and returns it in vector Y.  If X is a matrix,
%    DETREND removes the trend from each column of the matrix.
% 
%    This routine automatically reshapes to remove the trend from the
%    first dimension.
% 
%    See also MEAN2
%
% https://www.aos.wisc.edu/~dvimont/matlab/NaN_Tools/detrend_NaN.html
   function y = detrend(x)

%  Reshape x if necessary, assuming the dimension to be 
%  detrended is the first

szx = size(x); ndimx = length(szx);
if ndimx > 2;
  x = reshape(x, szx(1), prod(szx(2:ndimx)));
end
 
n = size(x,1);
if n == 1,
  x = x(:);			% If a row, turn into column vector
end
[N, m] = size(x);
y = repmat(NaN, [N m]);

for i = 1:m;
  kp = find(~isnan(x(:,i)));
  a = [(kp-1)/(max(kp)-min(kp)) ones(length(kp), 1)];  %  Build regressor
  y(kp,i) = x(kp,i) - a*(a\x(kp,i));
end

if n == 1
  y = y.';
end

%  Reshape output so it is the same dimension as input

if ndimx > 2;
  y = reshape(y, szx);
end