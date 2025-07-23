function varargout=tradeoffplot(TO,PlotStruct);
% tradeoffplot - make a tradeoff plot
%
%  Syntax
%   tradeoffplot(TO) where TO is output from hotspot.m
%
%   h=tradeoffplot will return handles to the plots (i.e. for legends)
%
%   tradeoffplot(TO,PlotStruct) where PlotStruct may have the fields
%     xstr
%     ystr
%     titlestr
%     plotstyle
%   see also:  hotspot.m

xstr=' good thing - % ';
ystr=(' bad thing - %');
titlestr=([' Bad thing used to produce a good thing ']);
plotstyle='b-';

if nargin==2
    expandstructure(PlotStruct);
end

h=plot(100*TO.goodquantitysorted/max(TO.goodquantitysorted),100*TO.badquantitysorted/max(TO.badquantitysorted),100*[0 1],100*[0 1]);
h=plot(100*TO.goodquantitysorted,100*TO.badquantitysorted,100*[0 1],100*[0 1]);
%h=plot(100*TO.goodquantitysorted/max(TO.goodquantitysorted),100*TO.badquantitysorted/max(TO.badquantitysorted),plotstyle);
xlabel(xstr);
ylabel(ystr);
title(titlestr);


grid on

zeroxlim(0,100);
%zeroylim(0,100);

if nargout==1
    varargout{1}=h;
end
