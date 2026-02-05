function quickview(sov,nametext);
% quickview - put up an excel of a structure of vectors
if nargin==0
    help(mfilename)
    return
end

if nargin==1
    nametext='';
end

fn=fieldnames(sov);

for j=1:numel(fn);

    y=sov.(fn{j});

    if iscell(y)

        for m=1:numel(y)
            y{m}=strrep(y{m},',','_');
        end

        sov.(fn{j})=y;
    end

end

filename=['tmpforquickview' '_' nametext '.csv'];

sov2csv(sov,filename);
excel(filename)

