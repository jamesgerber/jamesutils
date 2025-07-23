function AddColorbarMinus(Handle)
% AddColorbarFinalPlus - add a "<" before the first number on colorbar
%
% SYNTAX
% AddColorbarPercent(h) - add < to the first number on the colorbar either
% specified by handle h or in the figure specified by handle h.
%
if nargin==0;
  Handle=gcf;
end

if fix(Handle)==Handle
  % Handle is an integer ... must be figure handle.  Assume it is an
  % IonEFigure and look for colorbar accordingly.
  fud=get(Handle,'UserData');
  cbh=fud.ColorbarHandle;
else
 % user passed in a non-integer handle. Assume it is a handle to a colorbar.
  cbh=Handle;
end


xtl=get(cbh,'XTickLabel');
N=size(xtl,1);
C=size(xtl,2);
for j=1:N;
  xtlcell{j}=xtl(j,:);
end

for j=1;  %only this line changed from AddColorbarPercent
    tmp=xtlcell{j};
    tmp=strrep(tmp,' ','');
    xtlcell{j}=['<' tmp ' '];
end

%set(cbh,'XTickLabel',xtlcell);
xtlnew= strvcat(xtlcell);
set(cbh,'XTickLabel',xtlnew);
set(cbh,'XTickMode','manual')





  
