function [Outline,CountryCodeList,OutputCountryNameList]=CountryNameToOutline(CountryNameList);
% COUNTRYNAMETOOUTLINE - return country outlines and name lists.
%
%     SYNTAX:
%        [Outline]=CountryNameToOutline(CountryNameList);  will return a
%        5 minute resolution grid of the earth with 0 everywhere except
%        at the locations of the countries in CountryNameList.
%        CountryNameList should be entered as a cell array.  It is not
%        case-sensitive.  The full name doesn't need to be entered, but
%        enough letters must be used to disambiguate.
%
%        [Outline,CountryCodeList,OutputCountryNameList]=CountryNameToOutli
%        ne(CountryNameList);
%
%
%        If CountryNameList is a single string, then Outline will be a
%        logical array.  
%
%        If CountryNameList is a cell array (even if it only contains a 
%        single string,) then Outline will be an array with CountryCodes. 
%
% Examples
%  
%
%  %% This will crash because Aus is ambiguous.
% CountryNameList={'Aus','Fra','Austria','Australia','Gabon'};
% [Outline]=CountryNameToOutline(CountryNameList);
%
% CountryNameList={'Fra','Austria','Australia','Gabon'};
% [Outline,Codes,Names]=CountryNameToOutline(CountryNameList);
% thinsurf(Outline)
%
% [Outline,Codes,Names]=CountryNameToOutline;
% Will return Outline of all countries, with codes and names.
% 
% [Outline]=CountryNameToOutline('China'); Returns a logical%
%
% [Outline]=CountryNameToOutline({'China'}); Returns China country code.
%
%  See Also  LoadPolitBoundary_5min
%

if nargin==0 && nargout==0
  help(mfilename)
  return
end
MakeOutlineBinary=0;
if nargin==1 
  if strmatch(lower(CountryNameList),'version');
    [CountryCodeList]=GetSVNInfo;
    return
  end
  
  if ~iscell(CountryNameList)
      CountryNameList={CountryNameList};
      MakeOutlineBinary=1;
  end
end



[UnitCodes,IDNames,UnitNames,CountryNames,CountryNumbers]=loadpolitboundary_5min;

if nargin==0
  CountryNameList=unique(CountryNames);
end

CountryNamesLower=lower(CountryNames);

c=1;
for j=1:length(CountryNameList)
    if nargin==0
        ii=strmatch(lower(CountryNameList{j}),CountryNamesLower,'exact');
    else
        ii=strmatch(lower(CountryNameList{j}),CountryNamesLower);
    end
  switch length(ii)
      case 0
              disp(['did not find ' CountryNameList{j}]);
      case 1
          Code(c)=CountryNumbers(ii);
          OutputCountryNameList(c)=CountryNames(ii);
          c=c+1;
      otherwise
          if length(unique(CountryNumbers(ii)))>1
              % this means more than one country
              display([CountryNameList{j} ' could mean:']);
              display(CountryNames(ii));
              iii=strmatch(lower(CountryNameList{j}),CountryNamesLower,'exact');
              if length(iii)~=1
                error([CountryNameList{j} ' is ambiguous']);
              else
                  Code(c)=CountryNumbers(iii);
                  OutputCountryNameList(c)=CountryNames(iii);
                  c=c+1;
              end
          else
              Code(c)=CountryNumbers(ii(1));
              OutputCountryNameList(c)=CountryNames(ii(1));
              c=c+1;
          end
  end
end
if c==1
    error(['Found no country matches'])
end
    
CountryCodeList=Code;




%  Call systemglobals to find default (and possibly user-specific) paths
try
  SystemGlobals
catch
    disp([' Didn''t find SystemGlobals.  ']);
    ADMINBOUNDARYMAP_5min    ='/Library/IonE/data/AdminBoundary/glctry.nc';
end

[Long,Lat,Data]=opennetcdf(ADMINBOUNDARYMAP_5min);

Data=floor(Data/100);

Outline=Data*0;
for j=1:length(Code)
ii=find(Data==Code(j));
Outline(ii)=Data(ii);
end


if MakeOutlineBinary==1;
  Outline(Outline==0)=0;
  Outline(Outline>0)=1;
  Outline=logical(Outline);
end
