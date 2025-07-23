function quickview(sov);
% quickview - put up an excel of a structure of vectors
if nargin==0
    help(mfilename)
    return
end

sov2csv(sov,'tmpforquickview.csv');
excel tmpforquickview.csv

