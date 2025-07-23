function [varargout]=MapZoom(long,lat,Map)
% MapZoom - limit dataset to user-selected region of the world
%
%
%  SYNTAX  [NewLong,NewLat,NewMap]=MapZoom(long,lat,Map)
%
%  EXAMPLE
%   S=testdata(4320,2160,1);
%   [NewLong,NewLat,NewMap]=MapZoom(S.Long,S.Lat,S.Data);
if nargin==0
    help(mfilename);
    return
end 
     
if ~isequal([length(long) length(lat)],size(Map))
    error('Size/Orientation of Map disagrees with long and lat');
end



load MapZoomMapData
hfig=figure
SBA=SBA-1;
surface(longsp,latsp,SBA.'*0,SBA.');
shading interp;
zoom on

uicontrol('callback','set(gcbf,''tag'',''Complete'')','string','Continue')

waitfor(hfig,'tag','Complete')


xlims=get(gca,'XLim');
ylims=get(gca,'YLim');
delete(hfig)


ii=find(lat>=xlims(1) & lat <= xlims(2));
jj=find(long>=ylims(1) & long <= ylims(2));


NewLong=long(jj);
NewLat=lat(ii);
NewMap=Map(jj,ii);


varargout{1}=NewLong;
varargout{2}=NewLat;
varargout{3}=NewMap;

