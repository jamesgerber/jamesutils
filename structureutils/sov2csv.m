function sov2csv(a,filename,delimiter,startfields,excludefields)
%sov2csv - write a structure of vectors to a .csv file
%

% syntax:
%       sov2csv(a,filename,delimiter,startfields)
%
%  will also handle a vos (vector of structures)
%
%

if nargin<2
    help(mfilename)
    return
end

if nargin<3
    delimiter=',';
end
if nargin<4
    startfields=fieldnames(a);
end

if nargin<5
    excludefields={};
end


if numel(a) >1
    disp(['This appears to be a vector of structures (vos) not an sov.  attempting to convert.'])
    a=vos2sov(a);
end

allfieldnames=fieldnames(a);

D=delimiter;
% going to reorder the fields

listOfIdxExclude=[];
listOfIdxInclude=[];

c=0;
for j=1:numel(startfields);

    idx=strmatch(startfields{j},allfieldnames,'exact');

    %     if numel(idx)>1
    %         error('non unique field names')
    %     end

    if numel(idx)==0
        error('this field name not in structure');
    end

    %     if numel(idxExclude)>1
    %         error('non unique field names')
    %     end

    %  if isempty(idxExclude)
    c=c+1;
    fieldList(c)=idx;
    listOfIdxInclude(end+1)=idx;
    %   end
end

%% don't really care about the excluding part right now.
% %     idxExclude=strmatch(startfields{j},excludefields,'exact');
% %
% %     if numel(idxExclude)==1
% %         listOfIdxExclude(end+1)=idxExclude;
% %     end
% %
% % end
% %
clear isanumericalfield

missingIdx=setdiff(1:numel(allfieldnames),listOfIdxInclude);

for m=1:numel(missingIdx);
    listOfIdxInclude(end+1)=missingIdx(m);
end



%  WTF this seems completely awful - looks like I had some dumb logic
%  because i write one less comma then there are fields ... but handled
%  differently when rewriting below ..
% fid=fopen(filename,'w');
% 
% for m=1:(numel(listOfIdxInclude)-1)
% 
%     fprintf(fid,'%s,',allfieldnames{listOfIdxInclude(m)})
% 
%     tempfield=getfield(a,allfieldnames{listOfIdxInclude(m)});
% 
%     isanumericalfield(m)= isnumeric(tempfield(1));
% 
% end
% fprintf(fid,'%s\n',allfieldnames{listOfIdxInclude(end)});
% tempfield=getfield(a,allfieldnames{listOfIdxInclude(m)});
% isanumericalfield(end+1)= isnumeric(tempfield(end)); % this used to be tempfield(1) ... seems like a bug.
% 

fid=fopen(filename,'w');

for m=1:(numel(listOfIdxInclude))

    fprintf(fid,'%s',allfieldnames{listOfIdxInclude(m)});

    tempfield=getfield(a,allfieldnames{listOfIdxInclude(m)});

    isanumericalfield(m)= isnumeric(tempfield(1));

    if m<numel(listOfIdxInclude)
        fprintf(fid,D);
    else
        fprintf(fid,'\n');

    end

end


for j=1:numel(getfield(a,allfieldnames{1}))

    for m=1:(numel(listOfIdxInclude)-1)
        thisfield=getfield(a,allfieldnames{listOfIdxInclude(m)});

        if isanumericalfield(m)
            fprintf(fid,['%f' D],thisfield(j));
        else
            fprintf(fid,['%s' D],thisfield{j});
        end
    end
    m=m+1;
    thisfield=getfield(a,allfieldnames{listOfIdxInclude(m)});


    if isanumericalfield(m)
        fprintf(fid,'%f\n',thisfield(j));
    else
        fprintf(fid,'%s\n',thisfield{j});
    end
end




end




