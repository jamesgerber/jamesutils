function true=closeto(x,x1,tol)
% CLOSETO determine approximate equality
%
%  Syntax:
%
%   a=CLOSETO(x,x1,[TOL]) checks if elements of x are within TOL of x1
%   (inclusive).   Default value of TOL is x1/1e-7
%
%  Example:   find( closeto(10:100,60,6) & closeto(10:100,70,4))
%

if nargin==2
   tol=abs(x1)*1e-7;
end

true = (x>=x1-tol & x<=x1+tol);
