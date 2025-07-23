function y=normdist(x,m,sig)
% NORMDIST - calculate normal distribution.
%
% SYNTAX
% y=normdist(x,m,sig) - set y to probability mass from minus infinity to
% x for mean m and standard deviation sig.

y=1/sqrt(2*pi)/sig*exp(- (x-m).^2/2/sig.^2);

