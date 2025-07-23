function ylimmax = nsgaddhist(NSGOS, mapdata, totalarea, ...
    xlimmax, ylimmax)
% function ylimmax = NSGaddhist(NSGOS, mapdata, totalarea, ...
%     xlimmax, ylimmax)
%
% add histogram to a figure made by nicesurfgeneral
%
%
%  x=getdata('maize');
% ma=x.Data(:,:,1);
% my=x.Data(:,:,2);
% ma(ma>9e9)=nan;
% my(my>9e9)=nan;
% clear NSS
% NSS.caxis=[0 12]
% OS=nsg(my,NSS,'title','Maize Yield','Filename','testingnsg');
% nsgaddhist(OS, my, ma, 12);
%%% PREPARE FIG

Hfig=gcf;
hideui

% move map up
set(NSGOS.mapaxishandle,'Position',[0.00625 0.29 0.9875 0.7])

% move units text down below colorbar

hcbtitle=get(NSGOS.colorbarhandle,'Title');
tmp = get(hcbtitle,'Position');
tmp(2) = tmp(2)-13.5;
set(hcbtitle,'Position',tmp);

% set(hcbtitle,'Position',[99.291 -10.8 1.00005])
% set(hcbtitle,'Position',[4.9882 3.35-13.5 1.0001])


%%% MAKE HISTOGRAM

% get good indices
ii = isfinite(totalarea) & totalarea>0;
areaii = totalarea(ii);
dataii = mapdata(ii);

% use Jamie's awhist code
histbins = 0:(xlimmax/10):xlimmax;
HS = awhist(dataii,areaii,histbins);

% get colormap info for hist
cm=NSGOS.cmap_final(2:end-1,1:3);
ii=floor(linspace(1,length(cm),length(histbins)));

% create hist in new fig window
histfig=figure;
delx=HS.bincenters(2)-HS.bincenters(1);
for j=1:length(HS.bincenters);
    thiscolor=cm(ii(j),:);
    hb=bar(HS.bincenters(j),HS.distbyweightedval(j),delx/1.25);
    hold on
    set(hb,'edgecolor',thiscolor,'facecolor',thiscolor);
end
if nargin > 4
    disp('setting the histogram y axis based on the value specified');
    ylim([0 ylimmax])
else
    tmp = ylim;
    ylimmax = tmp(2);
end
    

% reassign to new window
hax=gca;
set(hax,'parent',Hfig);
delete(histfig);

set(hax,'position',[0.1221    0.1000    0.7558    0.0257]+[0 0.05 0 0.15]);
set(hax,'fontsize',12)

hxlabel=get(hax,'xlabel');
set(hxlabel,'fontsize',12)

hylabel=get(hax,'ylabel');
set(hylabel,'fontsize',12)

set(hax,'xlim',[NSGOS.coloraxis(1) NSGOS.coloraxis(2)])
set(hax,'visible','off')

% OutputFig('Force',NSGOS.ActualFileName);
print(Hfig,'-dpng','-r400',NSGOS.ActualFileName); 
print(Hfig,'-depsc','-r400',NSGOS.ActualFileName); 

% set(NSGOS.colorbarhandle,'Position',[0.1221 0.1 0.7558 0.0257]);
% cbh=NSGOS.colorbarhandle;
% set(get(cbh,'Title'),'string','') %%% THIS TAKES AWAY THE UNITS
%hnew=axes('position',[0.1221    0.1000    0.7558    0.0257]+[0 .0257 0 .05])
%%% NOT SURE IF WE NEED THIS - makes the map smaller
% set(NSGOS.mapaxishandle,'position',[0.0063    0.3500    0.9875    0.6000])

