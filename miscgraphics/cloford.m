function [rgb]=cloford(colorname);
% return an rbg vector from cloford500 colors .xls name
persistent a

if isempty(a)

    a=readgenericcsv(['~/Public/ionedata/misc/cloford500colors.csv']);
end

if nargin==0
    a.Name2
    return
end
idx=strmatch(colorname,a.Name2,'exact');

if numel(idx)~=1
    error(['did not find this name: ' colorname]);
else
    rgb=[a.r(idx) a.g(idx) a.b(idx)]/255; 
end