function addHorizontal(hax,yval,lineproperties)
% add a Horizontal line to current axes
%
%  Syntax 
%        addHorizontal(hax,XVAL)
%        addHorizontal(hax,XVAL,{'color','black','linestyle',':','linewidth',0.5})
%
% see also addVertical

if nargin<3
    lineproperties={'color','black','linestyle',':'}
end

xx=get(hax,'XLim');
axes(hax)
line(xx,[yval yval],lineproperties{:});
