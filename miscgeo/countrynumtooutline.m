function [iiRegion,RegionName]=CountryNumToOutline(j);
% CountryNumToOutline - turn a sage country number to an outline & name
%
% Syntax
%        [iiRegion,RegionName]=CountryNumToOutline(SageNumber);
%
% EXAMPLE
%   NSG(CountryNumToOutline(ceil(rand*237)));
persistent IndicesWithSageNames NS
if isempty(IndicesWithSageNames)
    NS=StandardCountryNames;
    ii=strmatch('',NS.Sage3,'exact');
    k=ones(size(NS.Sage3));
    k(ii)=0;
    IndicesWithSageNames=find(k);
end

idx=IndicesWithSageNames(j);

iiRegion=CountryCodetoOutline(NS.Sage3(idx));
RegionName=char(NS.SageCountryNoComma(idx));
  

