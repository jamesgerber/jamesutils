function DS=ReadGenericCSV(FileName,HeaderLines,Delimiter,AttemptNums,headerlineoverride);
% ReadGenericCSV - Read in a CSV file - whatever is in the columns
%
%  Syntax
%
%     DS=ReadGenericCSV(FileName);   this will assume a single
%     header line
%
%     DS=ReadGenericCSV(FileName,HeaderLines);
%
%     DS=ReadGenericCSV(FileName,HeaderLines,Delimiter);
%
%     DS=ReadGenericCSV(FileName,HeaderLines,Delimiter,AttemptNums);
%
%     DS=ReadGenericCSV(FileName,HeaderLines,Delimiter,AttemptNums,headerline);
%
%   ReadGenericCSV will read in a CSV file, and make a structure,
%   where each field of the structure corresponds to one of the columns.
%
%   Delimiter is comma by default, but can become tab which is useful if
%   datasets contain commas
%
%   AttemptNums default is 0.  if set to 1, then any column which appears
%   to contain numbers will be read in that way.  This fails if any of
%   those columns then turn out to contain text.  However, if the columns
%   contain empty values, they are turned into NaN.
%
%   The number of columns will be determined by the number of
%   commas after the header (as determined by HeaderLines)   This
%   way, if there are extra commas in the header, the data field
%   names may be messed up, but the data will be extracted.
%
%   It is possible to override the headerline in the file with a fifth
%   input argument.  This can serve to override the headerline in the file
%   (HeaderLines>0), or it can be the headerline (HeaderLines==0)    [This
%   syntax hasn't been tested carefully]
%
%   This function is very sensitive to files that have unexpected cells
%   somewhere below the first two lines.
%
%
%  See Also:  csv2tabdelimited
%
% first get headers, then figure out what the individual columns look like

if nargin==0
    help(mfilename)
    return
end

if nargin==1
    HeaderLines=1;
end
if nargin<3
    Delimiter=',';
end
if nargin<4
    AttemptNums=0;
end

fid=fopen(FileName);

for m=1:(HeaderLines-1)
    x=fgetl(fid)
    fprintf(1,'%s\n',x);
end

headerline=fgetl(fid);

%disp(['****** here is the headerline: ******'])
%    fprintf(1,'%s\n',headerline);

headerline=FixUpHeaderline(headerline);

if nargin==5
    headerline=headerlineoverride;
    fclose(fid);
    fid=fopen(FileName);
    
    for m=1:(HeaderLines-1)
       x= fgetl(fid);
    end
end

VC=GetStrings(headerline,Delimiter);  %function below.
FieldNameStructure.Vector=VC;

% Now go through the structures and concatenate everything to get
% field names

if length(FieldNameStructure)>1
    warning(['do not have ability to turn multiple headerlines into' ...
        ' unique field names']);
    FieldNameStructure=FieldNameStructure(1);
end


% Now consider first line
xline=fgetl(fid);

VC=GetStrings(xline,Delimiter);

dvals=str2double(VC);

formatstring='';
for j=1:length(dvals);
    %this if/else below is due to the fact that I originally wrote out a
    %format string based on the first line of data.  However, I came across
    %some files that mixed numbers and strings within a column.
    %Consequently, I read in everything as a string and handle for
    %string/number further below.
    %I'm leaving this syntax here in case I want to try to go back (of
    %course, would need conditional statements ... lots of code, but might
    %run faster.)
    
    if isnan(dvals(j))
        %it's a string
        formatstring=[formatstring '%s'];
    else
        %it's a number
        if AttemptNums==1
            formatstring=[formatstring '%f'];
        else
            formatstring=[formatstring '%s'];
        end
    end
    
end
%now can read the whole thing using textscan

fclose(fid);

if length( find(formatstring=='%') )== (length(find(xline==Delimiter))+1)
    
    fid=fopen(FileName);
    C=textscan(fid,formatstring,'Delimiter',Delimiter,'HeaderLines',HeaderLines,'EmptyValue',NaN);
    fclose(fid);
else
    
    disp([' problem with number of delimiters apparently in the file '])
  
    legacy=1
    if legacy==1
        discrepancy=(length(find(xline==Delimiter))+1)-length( find(formatstring=='%') );
    
        for j=1:(discrepancy);
            formatstring=[formatstring '%s'];
        end
    else
        formatstring='';

        for j=1:length(find(headerline==Delimiter))+1
            formatstring=[formatstring '%s'];
        end
    end    
    fid=fopen(FileName);
    C=textscan(fid,formatstring,'Delimiter',Delimiter,'HeaderLines',HeaderLines,'EmptyValue',NaN);
    fclose(fid);
    
    
end
%% OK.  Now have everything.  Assemble into DS (Output Structure).
DS=[];
if AttemptNums==0
    
    for j=1:length(C)
        if ~isempty(FieldNameStructure.Vector{j})
            ThisName=makesafestring(FieldNameStructure.Vector{j});
            Contents=C{j};
            
            %let's see if we can turn these values into doubles
            NumValue=str2double(Contents{1});
            if ~isnan(NumValue)
                % first element is a number.  Now try to get all of them:
                NumVector=str2double(Contents);
                if any(isnan(NumVector))
                    NumericFlag=0;
                    kk=find(isnan(NumVector));
                    disp(['attempted to interpret ' ThisName ' as numbers. ' ...
                        'Found a problem starting in line ' int2str(kk(1))]);
                else
                    NumericFlag=1;
                end
            else
                NumericFlag=0;
            end
            
            try
                % deal with this problem: "﻿" at beginning of .csv files
                ThisName=removeasciiturds(ThisName);
            ThisName=makesafestring(ThisName); % sometimes leaves blanks up front   
            end
            
            if NumericFlag==1
                DS=setfield(DS,makesafelocal(ThisName),NumVector);
            else
                DS=setfield(DS,makesafelocal(ThisName),Contents);
            end
            origfieldnames{j}=ThisName;
        end
    end
else
    for j=1:length(C)
        if ~isempty(FieldNameStructure.Vector{j})
            ThisName=makesafestring(FieldNameStructure.Vector{j});
            Contents=C{j};
            
            %             %let's see if we can turn these values into doubles
            %             NumValue=str2double(Contents{1});
            %             if ~isnan(NumValue)
            %                 % first element is a number.  Now try to get all of them:
            %                 NumVector=str2double(Contents);
            %                 if any(isnan(NumVector))
            %                     NumericFlag=0;
            %                 else
            %                     NumericFlag=1;
            %                 end
            %             else
            %                 NumericFlag=0;
            %             end
            %
            %             if NumericFlag==1
            %                 DS=setfield(DS,ThisName,NumVector);
            %             else
  try
      DS=setfield(DS,ThisName,Contents);
  catch
      DS=setfield(DS,removeASCIIturds(ThisName),Contents);

  end
      
      %             end
            
        end
    end
end

if numel(FieldNameStructure.Vector)==1
    return
end

%% is final field the same length as the others?
ThisName=makesafestring(FieldNameStructure.Vector{j});
PrevName=makesafestring(FieldNameStructure.Vector{j-1});

if ~isequal(length(getfield(DS,ThisName)),length(getfield(DS,PrevName)))
    
    warndlg(['Last vector not the right size.  this usually happens when the very last element of the file is a ' ...
        'comma because the last column/row of the .csv was blank.  easiest way' ...
        'to fix is to put an extra comma at the end.  see notes in this file' ...
        'for some unix tricks on dealing with this.  Or, add a dummy value to the' ...
        ' .csv    For now, going to fix it.']);
        %!echo "," > comma.tmp
        %!cat testdataset.csv comma.tmp > trythis.csv
        
        lastfield=getfield(DS,ThisName)
        prevfield=getfield(DS,PrevName);
        
        if isnumeric(lastfield)
            warning([' adding Nan to last element of ' ThisName ]);
            lastfield(numel(prevfield))=nan;
        elseif iscell(lastfield)
            warning([' adding {''} to last element of ' ThisName ]);
            lastfield(numel(prevfield))={''};
        else
            error(' didn''t know I could have this kind of field here')
        end
        
        DS=setfield(DS,ThisName,lastfield);
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        FixUpHeaderline     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function headerline=FixUpHeaderline(headerline);
headerline=strrep(headerline,'(','');

headerline=strrep(headerline,')','');

if isequal(headerline(1),'_')
    headerline=FixUpHeaderline(headerline(2:end));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        GetStrings          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function VC=GetStrings(xline,Delimiter)

% check to make sure that very last character of xline isn't Delimiter
if isequal(xline(end),Delimiter)
    disp(['found last line of xline is delimiter.  added code to fix Aug 2014 -jsg']);
    
    badcondition=isequal(xline(end),Delimiter);
    
    while badcondition
        xline=xline(1:end-1);
        badcondition=isequal(xline(end),Delimiter);
    end
end


ii=find(xline==Delimiter);





%stick a one on the beginning, and an N on the end.
% cumbersome, but then we can loop into the part where we make a structure
ii(2:length(ii)+1)=ii;
ii(1)=0;
ii(end+1)=length(xline)+1;

for j=1:length(ii)-1;
    VC{j}=xline(ii(j)+1 : ii(j+1)-1);
end


function out=makesafelocal(in)
% remove things that can't be ain a structure name.  functionally like
% makesafestring but that makes changes that could break something

out=strrep(in,':','');
out=strrep(out,'?','');
