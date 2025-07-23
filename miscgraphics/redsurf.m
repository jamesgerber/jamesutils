function varargout=RedSurf(Long,Lat,Data);
% REDSURF Surface plot for a reduced dataset
%
% SYNTAX
% h=RedSurf(Long,Lat,Data) - plot Data with IonESurf and return the figure
% handle
if nargin==0
  help(mfilename);
  return
end
    
titlestr=inputname(nargin);

if nargin==1
  % first argin is Data
  Data=Long;

  % need some matlab witchcraft to get Long and Lat
  Long=evalin('base','LongRed');
  Lat =evalin('base','LatRed');
end

h=IonESurf(Long,Lat,double(Data),'','');

if nargout==1
    varargout{1}=h;
end
