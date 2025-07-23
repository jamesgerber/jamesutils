function Outline=getOECDincomeoutline(incomelevel)
% getOECDincomeoutline - get outlines of OECD income levels
%
%   Syntax
%     Outline=getOECDincomeoutline('high');  
%
%  These are the levels
%   'High income: OECD'
%   'High income: nonOECD';
%   'Upper middle income'
%   'Lower middle income'
%   'Low income'
%
%     Outline=getOECDincomeoutline('high');  gives combination of first two
%     Outline=getOECDincomeoutline('mid');   gives Upper and Lower middle 
%     Outline=getOECDincomeoutline('low');   gives "Low income"
%
%     Outline=getOECDincomeoutline('ii1'); just 'High income: OECD'
%     Outline=getOECDincomeoutline('ii2'); just 'High income: nonOECD'
%     Outline=getOECDincomeoutline('um'); just 'Upper middle income'
%     Outline=getOECDincomeoutline('lm'); just 'Lower middle income'
%     Outline=getOECDincomeoutline('low');   just "Low income"
%
%
%   EXAMPLE
%       NSG(getOECDincomeoutline('high'));
%  
path = [iddstring 'misc/wbiclass.csv'];
WBI = ReadGenericCSV(path);

WBIhtable = java.util.Properties;
for j=1:length(WBI.countrycode);
    income = WBI.class{j};
    % get rid of divisions between OECD and non-OECD high income
    % countries
    if strmatch('High',income);
        income = 'High income';
    end
    WBIhtable.put(WBI.countrycode{j},income);
end


ii1=strmatch('High income: OECD',WBI.class);
ii2=strmatch('High income: nonOECD',WBI.class);
ii3=strmatch('Upper middle income',WBI.class);
ii4=strmatch('Lower middle income',WBI.class);
ii5=strmatch('Low income',WBI.class);

switch lower(incomelevel)
    case {'high'}
        ii=unique([ii1' ii2']);
    case {'middle','mid'}
        ii=unique([ii3' ii4']);
    case {'low','lo'}
        ii=ii5';
    case {'upper middle','um'}
        ii=ii3';
    case {'lm','lower middle'}
        ii=ii4'; 
    case {'high_non','ii2'}
        ii=ii2';
    case {'ii1','hioecd'}
        ii=ii1';
end



Outline=(DataMaskLogical==2);  % create big logical array of zeros
Outline=double(Outline);

ii=ii(:)';

a=StandardCountryNames(WBI.countrycode,'sage3');
b=standardcountrynames(WBI.country,'sagecountry');

for j=ii;
    sagenum=a{j};
    %display sagenum
 %   if j==82
 %       warning('fix honduras please')
 %   else    
        Outline=Outline + CountryCodetoOutline(a{j});
 %   end
end

Outline=logical(Outline);