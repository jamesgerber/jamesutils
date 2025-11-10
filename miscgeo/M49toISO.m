function [ISO,CountryName]=M49toISO(M49);
% M49toISO - turn an M49 Code into an ISO Code

persistent a
if isempty(a)
    a=readgenericcsv('countrynamesISOm49.txt',1,tab,1);
end

idx=find(a.M49_code==M49)

if isempty(idx)
    ISO='';
    CountryName='';
else
ISO=a.ISO_alpha3_code{idx};
CountryName=a.Country_or_Area{idx};
end