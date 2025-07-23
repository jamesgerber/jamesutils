function out=pullfromsov(SOV,ValueField,varargin);
% pullfromsov - return a particular field.
%
%  this allows for in-line code.
%
%   Syntax
%     pullfromSOV(StructOfVectors,'VALUEFIELD',criterionfield1,criterionvalue1);
%     pullfromSOV(StructOfVectors,'VALUEFIELD',criterionfield1,criterionvalue1,criterionfield2,criterionvalue2);
%
%   if ValueField result is empty then return 'NaN'
%
%   ideas for changes:
%     overload so first element of varargin is a flag that governs changes
%     in behavior when ValueField is empty (odd size(varargin) means 1st
%     element is that flat)
%

if nargin==0
    help(mfilename)
    return
end
  
Ncriteria=numel(varargin)/2;


for j=1:Ncriteria;
    field=varargin{ (j-1)*2+1};
    value=varargin{ (j-1)*2+2};

    if isnumeric(value);
        ii=find(SOV.(field)==value);
    else
%        ii=strmatch(value,SOV.(field),'exact');
        ii=find(strcmp(SOV.(field),value));
    end

    SOV=subsetofstructureofvectors(SOV,ii);
end


out=SOV.(ValueField);

if isempty(out)
    out=nan;
end