function newmap=StretchColorMap(cmap,cmin,cmax,center);
%  StretchColorMap - stretch out a colormap 
%
%     Use this if data goes from negative to positive but isn't
%     centered
%
%   SYNTAX
%   newmap=StretchOutColorMap(cmap,cmin,cmax,center) - set newmap to a new
%   version of colormap cmap between cmin and cmax, centered on center.
%
%
%   Example
%
%   M=getdata('maize');
%   W=getdata('wheat');
%   DelYield=M.Data(:,:,2)-W.Data(:,:,2);  %meaningless data
%   clear NSS
%   NSS.FastPlot='on';
%   NSS.colormap='orange_white_purple_deep';
%   NSS.caxis=[-5 15];
%   NiceSurfGeneral(DelYield,NSS)
%   cmap=finemap('orange_white_purple_deep','','');
%   NewMap=StretchColorMap(cmap,-5,15);
%   NSS.caxis=[-5 15];
%   NSS.colormap=NewMap;
%   NiceSurfGeneral(DelYield,NSS)
%

if nargin<4
    center=0;
end
if (cmin-center)*(cmax-center) > 0
  warndlg([' cmin cmax the same sign. doing something cheesy']);

  samesign=1;
else
      samesign=0;

  
end


if cmin > cmax
  error
end

if ischar(cmap)
    cmap=finemap(cmap,'','');
end

[N,~]=size(cmap);

mid=round(N/2);

neg= -(cmin-center)/(cmax-cmin);
pos= (cmax-center)/(cmax-cmin);

cmapneg=cmap(1:mid,1:3);
cmappos=cmap(mid:end,1:3);


if neg/pos > 1
  % more negative than positive.
  % don't touch the neg values, remove some of the pos values
  
  ii=floor(linspace(mid,N,mid*(pos/neg)));
  tmp=cmap(ii,1:3);
  newmap=[cmapneg ; tmp];
else

 ii=floor(linspace(1,mid,mid*(neg/pos)));
  tmp=cmap(ii,1:3);
  newmap=[tmp; cmappos];
end

%if samesign==1
%    newmap=3
%end
