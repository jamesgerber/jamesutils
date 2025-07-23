function mat=CRUImport(filename,gridx,gridy,mult)
% CRUImport - import monthly historical data formatted like CRU TS 2.1
%
% SYNTAX
% mat=CRUImport(filename,gridx,gridy,mult) - import data in filename,
% assuming it's on a grid of size gridx*gridy.  Multiply by mult.
% gridx,gridy are 720,360 by default.
% mult is 1 by default.
if nargin<3
    gridx=720;
    gridy=360;
end
display('Importing data...');
A=importdata(filename,'\n');
display('Rendering matrix...');
w=waitbar(0.0,'Rendering matrix...');
while 1
    if (isempty(strfind(A{1},'Grid-ref')))
        A(1)=[];
    else
        break;
    end
end
per=0;
while 1
    if (isempty(strfind(A{per+2},'Grid-ref')))
        per=per+1;
    else
        break
    end
end
Aref=A(1:(per+1):length(A));
A(1:(per+1):length(A))=[];
mat=zeros(gridx,gridy,12,per);
for i=1:length(Aref)
    waitbar(i/length(Aref),w);
    Sref=textscan(Aref{i},'Grid-ref= %d, %d');
    for j=1:per
%         J=A{(i-1)*per+j};
%         for (mo=1:12)
%             mat(Sref{1},gridy-Sref{2}+1,mo,j)=str2double(J((mo*5):(mo+4)));
%         end
        S=textscan(A{(i-1)*per+j},'%d %d %d %d %d %d %d %d %d %d %d %d');
        try
            mat(Sref{1},gridy-Sref{2}+1,:,j)=[S{:}];
        catch
            J=A{(i-1)*per+j};
            J=['     ' J];
            J(1:(length(J)-60))=[];
            for mo=1:12
                mat(Sref{1},gridy-Sref{2}+1,mo,j)=str2double(J(mo:(mo+5)));
            end
        end
    end
end
if nargin==4
    mat=mat*mult;
end
delete(w);