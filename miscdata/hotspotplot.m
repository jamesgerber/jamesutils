function varargout=hotspotplot(HS,PlotStruct)
% hotspotplot - make a hot spot plot
%
% Syntax:
%   hotspotplot(TO) where TO is output from hotspot.m
%
%   h=hotspotplot will return handles to the plots (i.e. for legends)
%
%   hotspotplot(TO,PlotStruct) where PlotStruct may have the fields
%     xstr
%     ystr
%     titlestr
%     plotstyle
%
% EXAMPLE
%   [A B C] = hotspot(testdata,testdata,testdata,50)
%   hotspotplot(A)
%
%
%   see also:  hotspot.m

xstr=' good thing - % ';
ystr=(' bad thing - %');
titlestr=([' Bad thing used to produce a good thing ']);
plotstyle='b-';

if nargin==2
    expandstructure(PlotStruct);
end

%h=plot(100*TO.goodquantitysorted/max(TO.goodquantitysorted),100*TO.badquantitysorted/max(TO.badquantitysorted),100*[0 1],100*[0 1]);
h=plot(100*HS.badquantitysorted/max(HS.badquantitysorted),100*HS.goodquantitysorted/max(HS.goodquantitysorted),plotstyle);
xlabel(xstr);
ylabel(ystr);
title(titlestr);


grid on

ZeroXlim(0,100);
ZeroYlim(0,100);

if nargout==1
    varargout{1}=h;
end


