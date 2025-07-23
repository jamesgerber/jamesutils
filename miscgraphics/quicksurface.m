function hfig=quicksurface(x,y,c);
% quicksurface - surface plot, undersample, rotate data matrix if necessary

if nargin==0
    help(mfilename)
    return
end


if nargin==1
    [m,n]=size(x);
    c=x;
    x=1:m;
    y=1:n;
end


Ndata=numel(c);

% let's say max size = 1e6;


N=ceil( (Ndata./1e6).^(1/2));


if size(c,1) ~= numel(y)
    surface(x(1:N:end),y(1:N:end),double(c(1:N:end,1:N:end).'));
else
    surface(x(1:N:end),y(1:N:end),double(c(1:N:end,1:N:end)));
end

shading flat
cf
hfig=gcf;