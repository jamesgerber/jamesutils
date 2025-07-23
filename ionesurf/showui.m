function ShowUI;
% ShowUI - show uicontrols in the current figure
%
%  See Also HideUI
Hfig=gcf;

h=get(Hfig,'children');
for j=1:length(h)
  if isequal( get(h(j),'type'),'uicontrol')
    set(h(j),'Visib','on');
  end
end

