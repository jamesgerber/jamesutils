function [Hotspot,Tradeoff,GI]=hotspot(area,goodthingperha,badthingperha,percentage,flags);
% HOTSPOT - determine Hotspots in a dataset
%
%   Hotspot determines which points are most associated with some undesired
%   characteristic.   It works in two ways:  it determines Hotspots, which
%   speak to the locations with the greatest 'bad thing' and it determines
%   Tradeoffs, which speak to the locations which provide 'good thing' at
%   the biggest cost in 'bad thing'
%
%
%   Syntax
%
%       [Hotspot,Tradeoff,GI]=hotspot(area,goodthingperha,badthingperha,N)
%
%       Tradeoff is a structure which contains fields
%           .RB   % relative badness, in other words, 100*N% of goodthing
%                 % results in 100*RB% of badthing
%           .ii   % indices of the set points which produce N% of goodthing
%                 % at the maximum cost (RB%) of badthing
%     .iigoodDQ   % indices of input vectors that passed data quality
%                 % checks (i.e. not NAN, or 9E9, or 0 area)
%   .sortsum_bad  % cumulative "bad" quantity sorted by worst rate
%  .softsum_good  % cumulative "good" quantity sorted by worst rate
%
%    Note that quantity is rate*area. This is why inputs include rates and
%    areas.
%
%     Hotspot structure is similar, except has RG instead of RB
%
%       To do a Hotspot calculation to analyze badthing per area, use '1'
%       for goodthingperha
%       GI is the Gini Index
%
%      Three likely uses for this code in terms of desired outputs
%         "25% of land contains 40% of excess N"    (Tradeoff)
%         "25% of yield is associated with 36% of excess N"  (Tradeoff)
%         "25% of excess N is found on 17% of land"  (Hotspot)
%
%       [Hotspot,Tradeoff,GI]=Hotspot(area,goodthingperha,badthingperha,N,flags)
%
%     where flags is a structure which may contain the fields
%     removenegativevalues
%     allownegativevalues
%  Example
%
%       S=OpenNetCDF([iddstring '/Fertilizer2000/maizeNapprate']);
%       Napp_per_ha=S.Data(:,:,1);
%       S=getdata('maize');
%       area=S.Data(:,:,1);
%       yield=S.Data(:,:,2);
%       ii=CountryCodetoOutline('USA');
%       [HS,TO]=Hotspot(area(ii).*fma(ii),1,Napp_per_ha(ii),20);
%       disp([ int2str(TO.RB*100) '% of N goes on 20% of maize crop area in US']);
%       [HS,TO]=Hotspot(area(ii).*fma(ii),yield(ii),Napp_per_ha(ii),20);
%       disp([ int2str(TO.RB*100) '% of N goes on 20% of maize produced in US']);
%       [HS,TO]=Hotspot(area(ii).*fma(ii),yield(ii),Napp_per_ha(ii),20);
%       disp([ int2str(HS.RG*100) '% of maize produced with 20% of applied N/ha in US']);
%
%       ii=LandMaskLogical;
%       [HS,TO]=Hotspot(area(ii).*fma(ii),1,Napp_per_ha(ii),20);
%       disp([ int2str(TO.RB*100) '% of N goes on 20% of maize crop area in world']);
%       [HS,TO]=Hotspot(area(ii).*fma(ii),yield(ii),Napp_per_ha(ii),20);
%       disp([ int2str(TO.RB*100) '% of N goes on 20% of maize produced in world']);
%       [HS,TO]=Hotspot(area(ii).*fma(ii),yield(ii),Napp_per_ha(ii),20);
%       disp([ int2str(HS.RG*100) '% of maize produced with 20% of applied N/ha in world']);
%
%    See Also:  justHotspot  justTradeoff hotspotplot

%    Here is the code I used to corroborate this against nature paper
%    results ...
%    [RB,areacutoff]=Hotspot(croparea(ii).*fma(ii),ones(size(find(ii))),ExcessNitrogenPerHA_avg(ii),10)
%
%
%
if percentage > 1
    percentage=percentage/100;
end

if mean(area)<1
    warning('area very small ... that''s probably fractional grid area, not area in ha')
end

if goodthingperha==1
    goodthingperha=ones(size(area));  % effectively a dummy dataset for yield so that the calculation focues on area
end

% flag section
removenegativevalues='off';
allownegativevalues='';

if nargin==5
    expandstructure(flags);
end

%% data quality check

switch lower(removenegativevalues)
    case {'off','no'}
        iigood= (~isnan(goodthingperha.*badthingperha.*area)) & ...
            area > 0 & area < 9e5;
    case {'on','yes'}
        iigood=(badthingperha > 0 ) & (~isnan(goodthingperha.*badthingperha.*area)) & ...
            area > 0 & area < 9e5;
    otherwise
        error
end



switch allownegativevalues
    case {'on','yes'}
        % do nothing
    otherwise
        if any(badthingperha(iigood)<0)
            warndlg([' Some of the bad thing is negative.  Sums will cancel out,' ...
                ' possibly leading to an overestimate of intensity of Hotspots '])
        end
end
area=area(iigood);
goodthingperha=goodthingperha(iigood);
badthingperha=badthingperha(iigood);

if isempty(find(iigood))
    RelativeBadness=-1;
    Tradeoff.RB=RelativeBadness;
    Tradeoff.ii=[];
    Tradeoff.iigood=iigood;
    
    RelativeGoodness=-1;
    Hotspot.RG=RelativeGoodness;
    Hotspot.ii=[];
    Hotspot.iigoodDQ=iigood;
    GI=[];
    return
end

%% Tradeoff - how much bad to get the amount of good?

% we sort by 'bad thing' rates
[dum,ii]=sort(badthingperha./goodthingperha,'descend');

% after sorting by rates, though, we don't want rates, we want rates*area
badquantity=badthingperha.*area;
goodquantity=goodthingperha.*area;

goodsort=goodquantity(ii);
badsort=badquantity(ii);

cumgood=cumsum(goodsort);
cumgood=cumgood/max(cumgood);

[dum,jj]=min( (cumgood-percentage).^2);

%

TotalBadness=sum(badsort);
PartialBadness=sum(badsort(1:jj));

RelativeBadness=PartialBadness/TotalBadness;

Tradeoff.RB=RelativeBadness;
Tradeoff.ii=iigood(ii(1:jj));
Tradeoff.iigoodDQ=iigood;

tmp=cumsum(badsort);
FinalBadSortValueSummed=tmp(end);

tmp=cumsum(goodsort);
FinalGoodSortValueSummed=tmp(end);

Tradeoff.badquantitysorted=cumsum(badsort)/FinalBadSortValueSummed;
Tradeoff.goodquantitysorted=cumsum(goodsort)/FinalGoodSortValueSummed;

%% Hotspot - how much good is associated with this amount of bad?

cumbad=cumsum(badsort);
cumbad=cumbad/max(cumbad);

[dum,kk]=min( (cumbad-percentage).^2);


TotalGoodness=sum(goodsort);
PartialGoodness=sum(goodsort(1:kk));

RelativeGoodness=PartialGoodness/TotalGoodness;

Hotspot.RG=RelativeGoodness;
Hotspot.ii=iigood(ii(1:kk));
Hotspot.iigoodDQ=iigood;
Hotspot.badquantitysorted=cumsum(badsort)/FinalBadSortValueSummed;
Hotspot.goodquantitysorted=cumsum(goodsort)/FinalGoodSortValueSummed;

% now calculate gini index
if nargout==3
    N=1000;
    xnew=Hotspot.badquantitysorted;
    ynew=Hotspot.goodquantitysorted;
    [dum,ii]=unique(xnew);
    xnew=xnew(ii);
    ynew=ynew(ii);
    
    xreg=linspace(xnew(1),xnew(end),N);
    
    yreg=interp1(xnew,ynew,xreg);
    
    L=(sum(yreg)/(length(yreg)));
    GI=1-2*L;
end

