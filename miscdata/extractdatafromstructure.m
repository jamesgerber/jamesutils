function [Long,Lat,Data,Units,TitleStr,NDS]=ExtractDataFromStructure(DS);
% EXTRACTDATAFROMSTRUCTURE - pull data out of a standard structure
%
%   Syntax
%
%     [Long,Lat,Data,TitleStr,Units,NDS]=ExtractDataFromStructure(DS);
%     NDS is a version of the structure without the data.
%
%   EXAMPLE
%     S=testdata(100,50,1);
%     ExtractDataFromStructure(S);
%
a=fieldnames(DS);

%% Data
ii=strmatch('data',lower(a),'exact');
if isempty(ii)
  error(['This structure has no field named "Data"'])
end

Data=getfield(DS,a{ii});
NDS=rmfield(DS,a{ii});


%% Units
ii=strmatch('units',lower(a));
if isempty(ii)
    Units='';
else
    Units=getfield(DS,a{ii});
end


%% if there is a missing value, replace with NaN
ii=strmatch('missing_value',lower(a));
if ~isempty(ii)
    MissingValue=getfield(DS,a{ii});
    Data(find(Data==MissingValue))=NaN;
end

%% Longitude 
%% Latitude
ii=strmatch('lon',lower(a));
jj=strmatch('lat',lower(a));
if isempty(ii) | isempty(jj)
  [Long,Lat]=InferLongLat(Data);
elseif length(ii)>1
    % here because there are multiple version of long
    % go through all matches, and pull out the one with the most elements.
    % This is a bit careless, but seems to work OK. Could be defeated if
    % there were a field called longdatavector containing a long
    % datavector.
    for k=1:length(ii);
      Long{k}=getfield(DS,a{ii(k)});
      NumElements=length(Long{k});
    end
      [dum,kk]=max(NumElements);
    Long=Long{kk};   
  Lat=getfield(DS,a{jj});
else
    % long/lat are defined
  Long=getfield(DS,a{ii});
  Lat=getfield(DS,a{jj});
end

%% Title
ii=strmatch('title',lower(a));
if length(ii)>1
    ii=ii(1);
end

if ~isempty(ii)
  TitleStr=getfield(DS,a{ii});
else
  TitleStr='';
end
