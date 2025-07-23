function makeLegendGeneral(cmap,dir,label,cmin,cmax)
% MAKELEGENDGENERAL - make a legend for a KMZ map
%
% SYNTAX
% makeLegendGeneral(cmap,dir,label,cmin,cmax) - make a KMZ legend and save
% it as legend.png. Inputs:
%   cmap - the colormap to use
%   dir - the directory to save legend.png in
%   label - the text label to place on the legend
%   cmin - the colorbar minimum
%   cmax - the colorbar maximum
%
format long g;
fig=figure('units','pixels','position',[500 500 300 300])
axes('position',[.15,.1,.7,.75],'visible','off')
colorbar('location','north')
colormap(cmap)
cmin
cmax
caxis([cmin cmax])
    text(.5,1.0,label,'horizontalalignment','center',...
        'verticalalignment','bottom','fontsize',12)
%     text(.5,.72,{'Opacity indicates percentage of',...
%         ['land used for ' tmps ' cultivation'],...
%         ['Minimum: ' num2str(tmin) '%'],['Maximum: ' num2str(tmax,3) '%']},...
%         'fontsize',12,'horizontalalignment','center','verticalalignment','top')

set(gcf,'PaperPositionMode','auto')
print -dbmp -r300 'tmp.bmp';
close(gcf)
a=imread('tmp.bmp');
a=imresize(a,[300 300]);
    a=imcrop(a,[0 20 300 80]);
   % copyfile('logo.png',[dir '/logo.png']);
    imwrite(a,[dir '/legend.png'],'png','Alpha',1.0-((a(:,:,1)>250)&(a(:,:,2)>250)&(a(:,:,3)>250))*.15);