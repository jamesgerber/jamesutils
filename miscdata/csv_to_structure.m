function [DS,NS]=CSV_to_structure(fileToRead1)
%CSV_to_structure  Imports data from the specified file
%
% Syntax:
% [DS,NS]=CSV_to_structure(fileToRead1)
% DS is a data structure whose field names are the header lines
% NS is a data structure whose field names are column numbers

% Import the file
newData1 = importdata(fileToRead1);

% Create new variables in the base workspace from those fields.
textdata=newData1.textdata;
numdata=newData1.data;


FieldNames=textdata(1,:);

% now populate the data structure (DS)
% will need determine the columns corresponding to numerical data.

DS=[];     % Need to define DS to get it started.
NS=[];
DataCol=1; % Define these both as one.  Increment as we go ...
TextCol=1;

for j=1:length(FieldNames);
 
    %Replace '.', '%', and ' ' from fieldnames.
    Name=strrep(FieldNames{j},'.','_');
    Name=strrep(Name,'%','pct');
    Name=strrep(Name,' ','');
    if ~isempty(str2num(Name(1)))
        %we get here if the name starts with a number ... cant'' be ...
        Name=['Val' Name];
    end
    
    ColName=['col' int2str(DataCol+TextCol-1)];
    
    if isempty(textdata{2,j})
        % if textdata of column j is empty, this is numerical.
        Value=numdata(:,DataCol);

        DS=setfield(DS,Name,Value);
        NS=setfield(NS,ColName,Value);
        DataCol=DataCol+1;
    else
        Value=textdata(2:end,TextCol);
        DS=setfield(DS,Name,Value);
        TextCol=TextCol+1;
        NS=setfield(NS,ColName,Value);
    end
end


