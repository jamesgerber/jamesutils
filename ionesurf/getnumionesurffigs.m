function n=getnumionesurffigs;
% getnumionesurffigs - determine how many ionesurf figures are open
h=allchild(0);
s=get(h,'tag');
n=length(strmatch('IonEFigure',s));

