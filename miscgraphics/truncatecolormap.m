function newmap=TruncateColorMap(cmap,cmin,cmax);
%  TruncateColorMap - TruncateColorMap out a colormap 
%
%     Use this if data goes from negative to positive but isn't
%     centered
%
%   Example
%
%   [M,am,ym]=getdata('maize');
%   [W,aw,yw]=getdata('wheat');
%   DelYield=am-aw;  %meaningless data
%   clear NSS
%   NSS.FastPlot='on';
%   NSS.colormap='orange_white_purple_deep';
%   NSS.caxis=[-5 15];
%   NiceSurfGeneral(DelYield,NSS)
%   cmap=finemap('orange_white_purple_deep','','');
%   NewMap=TruncateColorMap(cmap,-5,15);
%   NSS.caxis=[-5 15];
%   NSS.colormap=NewMap;
%   NiceSurfGeneral(DelYield,NSS)
%
%  See Also StretchColorMap
if cmin*cmax > 0
  error([' cmin cmax the same sign.']);
end


if cmin > cmax
  error
end

%cmap=finemap(cmap,'','')

[N,dum]=size(cmap);

mid=round(N/2);

neg= -cmin/(cmax-cmin);
pos= cmax/(cmax-cmin);

cmapneg=cmap(1:mid,1:3);
cmappos=cmap(mid:end,1:3);


if neg/pos > 1
  % more negative than positive.
  % don't touch the neg values, remove some of the pos values
  
 % ii=floor(linspace(mid,N,mid*(pos/neg)));
  ii=floor(mid:mid*(pos/neg));
  tmp=cmap(ii,1:3);
  newmap=[cmapneg ; tmp];
else

% ii=floor(linspace(1,mid,mid*(neg/pos)));
  ii=floor(mid*(1-neg/pos):mid);

  if ii(1)==0
      ii=ii(2:end);
  end
  
  tmp=cmap(ii,1:3);

  newmap=[tmp; cmappos];
  end
