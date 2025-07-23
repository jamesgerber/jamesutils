function AddCountryCoasts(ListOfCountries,LineWidth,LineColor,HFig);
%  ADDCOUNTRYCOASTS - add coasts with list of countries, ISO names
%
%  AddCountryCoasts({'MEX','FRA','ITA'})  will
%
%  AddCountryCoasts({'MEX','FRA','ITA'},0.1)  will add some very thin lines
%
%  AddCountryCoasts({'MEX','FRA','ITA'},0.5,[1 .5 .5])  will add some fuschia lines
%
%  See Also  AddStates AddCoasts
%
%  Note that the three-digit code are the ISO codes, not the FAO codes.
%
%
%  Example
%
%
%   nsg(cropmasklogical,'PlotStates','off')
%   AddCountryCoasts({'MEX','FRA','ITA'},2);
%
%
if nargin==0
    help(mfilename)
    return
end

load IndividualCountryOutlines

if nargin==1
  HFig=gcf;
  LineWidth=0.5;
  LineColor=[0 0 0];
end

if nargin==2
        LineColor=[0 0 0];
        Hfig=gcf;
end

if nargin==3
    Hfig=gcf;
end
    
    
    

hax=gca;
   

holdstatus=ishold;
hold on

for j = 1:length(ListOfCountries)
    
    
    index=strmatch(ListOfCountries{j},NameList_ISO);
    
    long=CountryList(index).long;
    lat=CountryList(index).lat;
    
    
    if ~ismap(gca)
        hp=plot(long,lat,'k');
        set(hp,'linewidth',LineWidth,'Color',LineColor);
    else
        hp=plotm(lat,long,'k');
        set(hp,'linewidth',LineWidth,'Color',LineColor);
    end
end

if holdstatus==0
    hold off
end