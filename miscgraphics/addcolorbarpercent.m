function AddColorbarPercent(Handle);
% ADDCOLORBARPERCENT - add a % sign to each number on colorbar
%
% SYNTAX
% AddColorbarPercent(h) - add % to each number on the colorbar either
% specified by handle h or in the figure specified by handle h.

if nargin==0;
  Handle=gcf;
end

%if fix(Handle)==Handle   % this must be Matlab2012b or something.
if fix(get(Handle,'Number'))==get(Handle,'Number');

% Handle is an integer ... must be figure handle.  Assume it is an
  % IonEFigure and look for colorbar accordingly.
  fud=get(Handle,'UserData');
  cbh=fud.ColorbarHandle;
else
 % user passed in a non-integer handle. Assume it is a handle to a colorbar.
  cbh=Handle;
end


%% old code jamie commenting out for first edit in many years - no idea how this broke

% % % 
% % % xtl=get(cbh,'XTickLabel');
% % % N=size(xtl,1);
% % % C=size(xtl,2);
% % % for j=1:N;
% % %   xtlcell{j}=xtl(j,:);
% % %   xtlcell_V2015{j}=char(xtl(j,:));
% % % end
% % % 
% % % 
% % % 
% % % for j=1:length(xtlcell);
% % %     tmp=xtlcell{j};
% % %     tmp=strrep(tmp,' ','');
% % %     xtlcell{j}=[tmp '%'];
% % % end
% % % 
% % % %set(cbh,'XTickLabel',xtlcell);
% % % %xtlnew= strvcat(xtlcell);   %matlat 2012b
% % % %set(cbh,'XTickLabel',xtlnew);  %matlab 2012b
% % % 
% % % set(cbh,'TickLabels',xtlcell_V2015)
% % % 
% % % set(cbh,'XTickMode','manual')
% % %  %%% following is a lame attempt to write my own strvcat
% % % %%FormatString=['%-' int2str(C+1) 's'];
% % % %%for j=1:length(xtlcell)
% % % %%xtlnew(N,(1:C+1))=sprintf(FormatString,xtlcell{j})
% % % %%end
% % % 

%% new code jamie inserting for first edit in many years - no idea how this broke
xtl=get(cbh,'XTickLabel');
N=size(xtl,1);
C=size(xtl,2);
for j=1:N;
  xtlcell{j}=xtl(j,:);
  tmp=char(xtl(j,:))
  xtlcell_V2015{j}=[tmp '%']
end


set(cbh,'TickLabels',xtlcell_V2015)
set(cbh,'XTickMode','manual')



  
