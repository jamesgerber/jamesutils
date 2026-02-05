function [M49,CountryName]=ISOtoM49(ISO);
% ISOtoM49 - turn an ISO Code into an M49 Code
%
% syntax
%       [M49,CountryName]=ISOtoM49(ISO);
%
% see also: M49toISO
persistent a
if isempty(a)
    a=readgenericcsv('countrynamesISOm49.txt',1,tab,1);
end

idx=strmatch(ISO,a.ISO_alpha3_code)

if isempty(idx)
    M49=[];
    CountryName='';
else
    M49=a.M49_code(idx);
    CountryName=a.Country_or_Area{idx};
end