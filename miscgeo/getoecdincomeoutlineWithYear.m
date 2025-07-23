function [Outline,ISOList,CountryNameList]=getoecdincomeoutlineWithYear(incomelevel,year)
% getOECDincomeoutline - get outlines of OECD income levels
%
%   Syntax
%     Outline=getOECDincomeoutline('high');
%     [Outline,ISOList]=getoecdincomeoutlineWithYear('high',2017); returns list of
%     countries (ISO codes)
%     [Outline,ISOList,NameLIst]=getoecdincomeoutlineWithYear('high',2017); returns list of
%     countries (ISO codes) along with names
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
%path = [iddstring 'misc/wbiclass.csv'];
%WBI = ReadGenericCSV(path);

%a=readgenericcsv('/Users/jsgerber/sandbox/jsg169bb_ygot_IndYears/SocialCategories/WB/WB_OECDIncomeGroupsnq.txt',2,tab);
a=readgenericcsv('~/DataProducts/ext/WorldBankData/IncomeGroups/WB_OECDIncomeGroupsnq.txt',2,tab);

if nargin==1
    year=2000;
end

incomecode=getfield(a,['Val' int2str(year)]);




ii1=strmatch('H',incomecode);
ii3=strmatch('UM',incomecode);
ii4=strmatch('LM',incomecode);
ii5=strmatch('L',incomecode,'exact');




switch lower(char(incomelevel))
    case {'high'}
        ii=unique([ii1']);
    case {'middle','mid','med'}
        ii=unique([ii3' ii4']);
    case {'low','lo'}
        ii=ii5';
    case {'upper middle','um'}
        ii=ii3';
    case {'lm','lower middle'}
        ii=ii4';
    case {'ii1','hioecd'}
        ii=ii1';
    otherwise
        error(['dont know' incomelevel])
end



Outline=(DataMaskLogical==2);  % create big logical array of zeros
Outline=double(Outline);

ii=ii(:)';
g0=getgeo41_g0;
gadm0codes=g0.gadm0codes;
raster0=g0.raster0;


% some special cases:  south sudan  - replace with sudan income

CountryList={};


c=0;
for j=ii;
    idx=strmatch(a.code{j},gadm0codes);

    if numel(idx)==1
        c=c+1;
        Outline=Outline | raster0==idx;
    
        ISOList{c}=a.code{j};
        CountryNameList{c}=g0.namelist0{idx};
    end
    % special case ... if sudan, also include south sudan

    if isequal(a.code{j},'SDN')
        idx=strmatch('SSD',gadm0codes);
        Outline=Outline | raster0==idx;
    end


end

Outline=logical(Outline);