function hs=thinsurface(x,y,z);
% thinsurface - call surface() after undersampling
%
%  quite different from thinsurf (which calls nsg() after undersampling)

maxsize=1000*2000;

N=floor(sqrt(numel(z)/maxsize))


hs=surface(x(1:N:end),y(1:N:end),double(z(1:N:end,1:N:end)))