function [Outline,CountryCodeList,UserCountryNameList,OutputCountryNameList]=CountryNameToOutlineInteractive(CountryNameList,inputRecord,Map,bigNameList,bigCodeList)
% COUNTRYNAMETOOUTLINE - return country outlines and name lists.
%
%     SYNTAX:
%        [Outline]=CountryNameToOutlineInteractive(CountryNameList);  will
%        return a .5-deg resolution grid of the earth with 0 everywhere 
%        except at the locations of the countries in CountryNameList.
%        CountryNameList should be entered as a cell array.  It is not
%        case-sensitive.  The full name doesn't need to be entered, but
%        enough letters must be used to disambiguate.
%        If a country is not found, the function will ask the user to
%        specify it differently.
%        [Outline,CountryCodeList,UserNames,ActualNames]=CountryNameToOutline(CountryNameList);
%
%        If CountryNameList is a scalar, the function will ask the user to
%        specify a certain number of locations.
%
%        CountryNameToOutlineInteractive(CountryNameList,[],Map) lets the user
%        specify the map used.
%
%        If the user quits midway through, Outline will be set to a cell
%        array representing the input till that point. This can be passed
%        back to CountryNameToOutlineInteractive as the second argument:
%        [...]=CountryNameToOutlineInteractive(CountryNameList,inputCell,...);
%
%        CountryNameToOutlineInteractive(CountryNameList,[],Map,bigNameList,bigCodeList)
%        also lets the user specify the country name/codes represented on
%        the map.
%
% Examples
%  
%
% CountryNameList={'Aus','Fra','Austria','Australia','Gabon'};
% [Outline]=CountryNameToOutlineInteractive(CountryNameList);
%
% CountryNameList={'Fra','Austria','Australia','Gabon'};
% [Outline,Codes,Names]=CountryNameToOutlineInteractive(CountryNameList);
% thinsurf(Outline)
%
% [Outline,Codes,UserNames,ActualNames]=CountryNameToOutlineInteractive;
% Will return Outline of all countries, with codes and names.
%
% [Outline]=CountryNameToOutlineInteractive({'China'}); Returns China country code.
%
% [Outline]=CountryNameToOutlineInteractive(5);
%
%  See Also  LoadPolitBoundary_5min
%

if nargin==0 && nargout==0
  help(mfilename)
  return
end

SystemGlobals;
fid=fopen([IoneDataDir '/AdminBoundary2005/Raster_NetCDF/1_Countries_0.5deg/ctry.dat'],'r');
newdata=textscan(fid,'%[^\n]');
fclose(fid);
newdata=(newdata{1,1});
if (nargin<2)
    inputRecord=cell(0);
end

if (nargin>=3)
    Data=Map;
else
    ncs=OpenGeneralNetCDF([IoneDataDir '/AdminBoundary2005/Raster_NetCDF/1_Countries_0.5deg/ctry_0.5.nc']);
    Data=ncs(1,5).Data;
    Data=floor(Data);
end

Outline=Data*0;

if (isscalar(CountryNameList))
    t=CountryNameList;
    CountryNameList=cell(t,1);
    for i=1:t
        CountryNameList{i}=num2str(i);
    end
end

if (nargin>=5)
    allnames=bigNameList;
    codes=bigCodeList;
else
    for i=1:length(newdata)
        current=newdata{i};
        current=regexp(strtrim(current),' ','split','once');
        allnames{i}=current{2};
        codes(i)=str2double(current{1});
    end
end
disp([allnames' num2cell(codes')]);
if nargin==0
  CountryNameList=allnames;
end

ConCountryNameList=CountryNameList;

CountryNamesLower=lower(allnames);

inputInd=1;
c=1;
j=1;
while j<=length(CountryNameList)
    if (isempty(CountryNameList{j}))
        j=j+1;
    else
        if nargin==0
            ii=find(strcmpi(CountryNameList{j},CountryNamesLower));
        else
            if (~isempty(strfind(CountryNameList{j},';')));
                strings=regexp(CountryNameList{j},';','split','once');
                CountryNameList{j}=strings{1};
                CountryNameList((j+2):(numel(CountryNameList)+1))=CountryNameList((j+1):numel(CountryNameList));
                ConCountryNameList((j+2):(numel(ConCountryNameList)+1))=ConCountryNameList((j+1):numel(ConCountryNameList));
                CountryNameList{j+1}=strings{2};
                ConCountryNameList{j+1}=ConCountryNameList{j};
            end
            ii=find(strncmpi(CountryNameList{j},CountryNamesLower,length(CountryNameList{j})));
        end
        switch length(ii)
        case 1
            Code(c)=codes(ii);
            UserCountryNameList(c)=ConCountryNameList(j);
            OutputCountryNameList(c)=allnames(ii);
            c=c+1;
            j=j+1;
        otherwise
            if length(codes(ii))>1
                % this means more than one country
                display([CountryNameList{j} ' is ambiguous and could mean:']);
                display(allnames(ii));
                iii=find(strcmpi(CountryNameList{j},CountryNamesLower));
                if length(iii)~=1
                    disp('What country or long/lat location(s) should I use instead? Refer to COUNTRYLIST.');
                    disp('Enter blank to skip or X to return the input so far and open COUNTRYLIST,');
                    disp('a country''s name or a semicolon-separated list or cell matrix of names,');
                    disp('an Nx2 matrix of NaN-separated long/lat polygons, lines, or points,');
                    if (inputInd<=numel(inputRecord))
                        tmp=inputRecord{inputInd};
                        display(['or a numerical code: --- ' tmp]);
                    else
                        tmp=input('or a numerical code: ','s');
                        inputRecord{numel(inputRecord)+1}=tmp;
                    end
                    inputInd=inputInd+1;
                    try
                        tmpE=evalin('base',tmp);
                        if ischar(tmpE)
                            CountryNameList{j}=tmpE;
                        elseif iscell(tmpE)
                            tmpstr='';
                            for r = 1:numel(tmpE)
                                tmpstr=[tmpstr,';',tmpE{r}];
                            end
                            tmpstr=tmpstr(2:length(tmpstr));
                            CountryNameList{j}=tmpstr;
                        elseif isscalar(tmpE)
                            Code(c)=tmpE;
                            tmpName='';
                            while isempty(tmpName)
                                try
                                    if (inputInd<=numel(inputRecord))
                                        tmpName=inputRecord{inputInd};
                                        display(['What country name should be used? --- ' tmpName]);
                                    else
                                        tmpName=input('What country name should be used? ','s');
                                        inputRecord{numel(inputRecord)+1}=tmpName;
                                    end
                                    inputInd=inputInd+1;
                                    tmpName=evalin('base',tmpName);
                                catch
                                end
                            end
                            UserCountryNameList{c}=ConCountryNameList{j};
                            OutputCountryNameList{c}=tmpName;
                            j=j+1;
                            c=c+1;
                        else
                            try
                                [Z,~]=vec2mtx(tmpE(:,2),tmpE(:,1),rot90(zeros(size(Outline)),1),[2,90,-180]);
                                Z=rot90(imfill(Z,'holes'),3);
                                [rows,cols]=LatLong2RowCol(tmpE(:,2),tmpE(:,1),Outline);
                                tmpCode=[];
                                while isempty(tmpCode)
                                    try
                                        if (inputInd<=numel(inputRecord))
                                            tmpCode=inputRecord{inputInd};
                                            display(['What country code should be used? --- ' tmpCode]);
                                        else
                                            tmpCode=input('What country code should be used? ');
                                            inputRecord{numel(inputRecord)+1}=tmpCode;
                                        end
                                        inputInd=inputInd+1;
                                    catch
                                    end
                                end
                                Outline(Z==1)=tmpCode;
                                Outline(rows,cols)=tmpCode;
                                UserCountryNameList{c}=ConCountryNameList{j};
                                OutputCountryNameList{c}=CountryNameList{j};
                                Code(c)=tmpCode;
                                j=j+1;
                                c=c+1;
                            catch
                                disp('Could not evaluate.');
                                CountryNameList{j}=tmp;
                            end
                        end
                    catch
                        CountryNameList{j}=tmp;
                    end
                    if strcmpi('x',CountryNameList{j});
                        COUNTRYLIST=[allnames', num2cell(codes')];
                        assignin('base','COUNTRYLIST',COUNTRYLIST);
                        evalin('base','openvar(''COUNTRYLIST'')');
                        Outline=inputRecord(1:(numel(inputRecord))-1);
                        CountryCodeList=[];
                        UserCountryNameList=[];
                        OutputCountryNameList=[];
                        return;
                    end
                else
                    Code(c)=codes(iii);
                    UserCountryNameList{c}=ConCountryNameList{j};
                    OutputCountryNameList(c)=allnames(iii);
                    c=c+1;
                    j=j+1;
                end
            else
                disp(['Did not find ' CountryNameList{j}]);
                disp('What country or long/lat location(s) should I use instead? Refer to COUNTRYLIST.');
                disp('Enter blank to skip or X to return the input so far and open COUNTRYLIST,');
                disp('a country''s name or a semicolon-separated list or cell matrix of names,');
                disp('an Nx2 matrix of NaN-separated long/lat polygons, lines, or points,');
                if (inputInd<=numel(inputRecord))
                    tmp=inputRecord{inputInd};
                    display(['or a numerical code: --- ' tmp]);
                else
                    tmp=input('or a numerical code: ','s');
                    inputRecord{numel(inputRecord)+1}=tmp;
                end
                inputInd=inputInd+1;
                try
                    tmpE=evalin('base',tmp);
                    if ischar(tmpE)
                        CountryNameList{j}=tmpE;
                    elseif iscell(tmpE)
                        tmpstr='';
                        for r = 1:numel(tmpE)
                            tmpstr=[tmpstr,';',tmpE{r}];
                        end
                        tmpstr=tmpstr(2:length(tmpstr));
                        CountryNameList{j}=tmpstr;
                    elseif isscalar(tmpE)
                        Code(c)=tmpE;
                        tmpName='';
                        while isempty(tmpName)
                            try
                                if (inputInd<=numel(inputRecord))
                                    tmpName=inputRecord{inputInd};
                                    display(['What country name should be used? --- ' tmpName]);
                                else
                                    tmpName=input('What country name should be used? ','s');
                                    inputRecord{numel(inputRecord)+1}=tmpName;
                                end
                                inputInd=inputInd+1;
                                tmpName=evalin('base',tmpName);
                            catch
                            end
                        end
                        UserCountryNameList{c}=ConCountryNameList{j};
                        OutputCountryNameList{c}=tmpName;
                        j=j+1;
                        c=c+1;
                    else
                        try
                            [Z,~]=vec2mtx(tmpE(:,2),tmpE(:,1),rot90(zeros(size(Outline)),1),[2,90,-180]);
                            Z=rot90(imfill(Z,'holes'),3);
                            [rows,cols]=LatLong2RowCol(tmpE(:,2),tmpE(:,1),Outline);
                            tmpCode=[];
                            while isempty(tmpCode)
                                try
                                    if (inputInd<=numel(inputRecord))
                                        tmpCode=inputRecord{inputInd};
                                        display(['What country code should be used? --- ' tmpCode]);
                                    else
                                        tmpCode=input('What country code should be used? ');
                                        inputRecord{numel(inputRecord)+1}=tmpCode;
                                    end
                                    inputInd=inputInd+1;
                                catch
                                end
                            end
                            Outline(Z==1)=tmpCode;
                            Outline(rows,cols)=tmpCode;
                            UserCountryNameList{c}=ConCountryNameList{j};
                            OutputCountryNameList{c}=CountryNameList{j};
                            Code(c)=tmpCode;
                            j=j+1;
                            c=c+1;
                        catch
                            disp('Could not evaluate.');
                            CountryNameList{j}=tmp;
                        end
                    end
                catch
                    CountryNameList{j}=tmp;
                end
                if strcmpi('x',CountryNameList{j});
                    COUNTRYLIST=[allnames', num2cell(codes')];
                    assignin('base','COUNTRYLIST',COUNTRYLIST);
                    evalin('base','openvar(''COUNTRYLIST'')');
                    Outline=inputRecord(1:(numel(inputRecord))-1);
                    CountryCodeList=[];
                    UserCountryNameList=[];
                    OutputCountryNameList=[];
                    return;
                end
            end
        end
    end
end
if c==1
    error(['Found no country matches'])
end
    
CountryCodeList=Code;



for j=1:length(Code)
Outline((Outline==0)&(Data==Code(j)))=Data((Outline==0)&(Data==Code(j)));
end
% 
% if MakeOutlineBinary==1;
%   Outline(Outline==0)=0;
%   Outline(Outline>0)=1;
%   Outline=logical(Outline);
% end