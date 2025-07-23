function cyclecolormaps(hfig)

if nargin==0
    hfig=gcf;
end
figure(hfig)

a=dir([iddstring '/misc/colormaps/*.tiff']);

tag=get(hfig,'tag')

if isequal(tag,'IonEFigure');
    
   for j=1:length(a)
    x=a(j).name(1:end-5)
    finemap(x);
    pause
end
else

for j=1:length(a)
    x=a(j).name(1:end-5)
    finemap(x,'','');
    pause
end
end