function K=gauss2d(N,k);
% gauss2d - 2 dimensional gaussian filter.  
%
%  hard wired so that filter goes out to 5 sigma
%
%  K=gauss2d(N,k);
%
%  This code has two parameters, arguably it should have three:  total size
%  of window for kernel, sigma of the gaussian, and sampling.  Right now it
%  has two, so i have effectively hardwired a relationship between those
%  three parameters - not necessarily wrong but I didn't think carefully
%  about it.
%
% jg, project drawdown.
disp(['warning - this code is terrible (see comments'])
x=5*linspace(-k,k,N);
y=x;

[xx,yy]=meshgrid(x,y);
K=exp(-(xx.^2+yy.^2)/2/k.^2);

K=K/sum(K(:));