function out=nanunique(x);
% unique but return only a single nan

if numel(find(isnan(x)))>0;
    out=unique(x(~isnan(x)));
    out(end+1)=nan;
else
    out=unique(x);
end

if numel(find(isinf(x)))>0
    warning(' had an inf value ... never handled this in code');
end
