function oldposition=expandaxes(A)
% EXPANDAXES - expand an axes to better fill its figure
%
% SYNTAX
% oldposition=expandaxes will set the current axes to position [0 0 1 1]
% and set oldposition to the previous position
% oldposition=expandaxes(A) uses given axes A instead of the current axes
%
% EXAMPLE
% nsg(easyinterp2(magic(5),4320,2160));
% set(gca,'position',[.5 .5 .1 .1]);
% expandaxes

if nargin==0
    A=gca;
end
oldposition=get(A,'position');
set(A,'position',[0 0 1 1]);