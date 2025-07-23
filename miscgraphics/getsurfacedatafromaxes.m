function [xx,yy,z]=GetSurfaceDataFromAxes(ha);
% GetDataFromAxes - Pull surface data out from a given axis handle
%
%  SYNTAX
%
%       [xx,yy,z]=GetSurfaceDataFromAxes(ha);
%
%       xx can be either a matrix or a column.
%       if mapping toolbox is being used, xx will be a matrix which does
%       not have indentical rows or columns
%
%       [x,y,z]=GetSurfaceDataFromAxes; will execute a gcbf, and if
%       gcbf is empty (e.g. it's not a callback) then will execute
%       a gcf
%
%       See Also:  WorldSummary, ZoomToMax
%


if nargin==0
  hfig=gcbf;
  if isempty(hfig)
    hfig=gcf;
  end
  ha=get(hfig,'CurrentAxes');
end

hc=get(ha,'Child');
 
for j=1:length(hc)
  if isequal(get(hc(j),'type'),'surface')
    
    xx=get(hc(j),'XData');
    yy=get(hc(j),'YData');
    z=get(hc(j),'ZData');
    % check to see if z is all zeros.  If so, we want
    % cdata.
    ii=find(~isnan(z) & z~=0 & z~=-1);  %need to add -1 since some codes 
    %put the color data at -1 so that lines take precedence
    if isempty(ii)
      z=get(hc(j),'CData');
    end
  end
end

x=xx;
y=yy;
