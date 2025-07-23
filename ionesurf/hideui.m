function HideUI;
% HIDEUI - hide uicontrols in the current figure
%
%  See Also ShowUI
Hfig=gcf;

h=get(Hfig,'children');
for j=1:length(h)
  if isequal( get(h(j),'type'),'uicontrol')
    set(h(j),'Visib','off');
  end
end

