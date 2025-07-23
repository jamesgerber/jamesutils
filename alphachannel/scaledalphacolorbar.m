function scaledalphacolorbar(cmap,graymap,newfilename,range);
% scaledalphacolorbar

newfilename='newlegend.png';

hfig=figure;
hax=gca;

finemap(cmap);
hcb=colorbar;
set(hcb,'location','south')
set(hcb,'Position',[.05 .05 .9 .9])
set(hax,'visible','off')

OutputFig('Force','tmpcolorbarfig.png');

close 

hfig=figure;
hax=gca;

finemap('gray');
hcb=colorbar;
%%set(hcb,'location','south')
set(hcb,'Position',[.05 .05 .9 .9])
set(hax,'visible','off')

OutputFig('Force','tmpcolorbarfiggray.png');

close
hfig=figure;
hax=gca;

finemap('revgray');
hcb=colorbar;
%%set(hcb,'location','south')
set(hcb,'Position',[.05 .05 .9 .9])
set(hax,'visible','off')

OutputFig('Force','tmpcolorbarfigrevgray.png');



cs=imread('tmpcolorbarfig.png');
gs=imread('tmpcolorbarfigrevgray.png');

Alpha=(double(255-gs(:,:,1))/255);

imwrite(cs,newfilename,'png','Alpha',double(Alpha));