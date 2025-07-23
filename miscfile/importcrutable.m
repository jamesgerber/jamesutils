function OS=importCRUTable(filename)
% IMPORTCRUTABLE - import data formatted like TYN CY 3.0
%
% SYNTAX
% OS=importCRUTable(filename) - output a struct containing a map for each
% column of filename.
%

fid=fopen(filename,'r');
head=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'HeaderLines',19);
head=head(2:numel(head));
X1=textscan(fid,'%s','whitespace','','delimiter','\n');
X1=X1{1,1};
X1(1)=[];
for i=1:length(X1)
    tmp=textscan(X1{i},'%s');
    tmp=tmp{1};
    while length(tmp)>18
        tmp{1}=[tmp{1} ' ' tmp{2}];
        tmp(2)=[];
    end
    X(i,:)=tmp;
end
load('CRUworld');
for j=1:length(head)
    st=head{j};
    tmp=zeros(size(Outline)).*NaN;
    eval(['OS.' st{1} '=tmp;']);
end
for i=2:size(X,1);
    st=X{i,1};
    code=CountryCodeList(strcmp(st,UserCountryNameList));
    if ~isempty(code)
        for j=1:length(head)
            st=head{j};
            M=str2num(X{i,j+1});
            eval(['OS.' st{1} '(Outline==code)=M;']);
        end
    end
end