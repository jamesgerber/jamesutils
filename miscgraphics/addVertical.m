function addVertical(hax,xval,lineproperties)
% add a vertical to current axes
%
%  Syntax 
%        addVertical(hax,XVAL)
%        addVertical(hax,XVAL,{'color','black','linestyle',':','linewidth',0.5})
%
% see also addyline

if nargin<3
    lineproperties={'color','black','linestyle',':'}
end

yy=get(hax,'YLim');
axes(hax)
line([xval xval],yy,lineproperties{:});
