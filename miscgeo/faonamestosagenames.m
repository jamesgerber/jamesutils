function [OutputNames,GroupNames,itemcodes]=FAONamesToSageNames(InputNames)
% FAONamesToSageNames  turn FAO Name into monfreda et al name
%
%
%  Syntax
%    [OutputNames,GroupNames,itemcodes]=FAONamesToSageNames(InputNames)
% 
%
%     Example:
%
% [OutputNames,GroupNames,itemcodes]=FAONamesToSageNames('Bambara beans')
% [OutputNames]=FAONamesToSageNames({'Bambara beans','"Coffee, green"'})    
%
%
%  This code looks in IoneDataDir '/misc' for a tab delimited file named
%  Reconcile_Monfreda_FAO_cropnames.txt.  
if nargin==0
    help(mfilename)
    return
end



persistent  Group Cropname_FAO Cropname_monfreda itemcode;
if isempty(itemcode)
    fid=fopen([iddstring '/misc/Reconcile_Monfreda_FAO_cropnames.txt']);
    C=textscan(fid,'%s%s%s%s','Delimiter',tab);
    fclose(fid);
    itemcode=C{1};
    Cropname_monfreda=C{2};
    Cropname_FAO=C{3};
    Group=C{4};
    
    if ~isequal(Group{1},'GROUP')
        error([' problem with Reconcile_Monfreda_FAO_cropnames'])
    end
    if ~isequal(Cropname_FAO{1},'Cropname_FAO')
        error([' problem with Reconcile_Monfreda_FAO_cropnames'])
    end
    if ~isequal(Cropname_monfreda{1},'CROPNAME_monfreda')
        error([' problem with Reconcile_Monfreda_FAO_cropnames'])
    end
    if ~isequal(itemcode{1},'ITEM_CODE')
        error([' problem with Reconcile_Monfreda_FAO_cropnames'])
    end
    Group=Group(2:end);
    Cropname_FAO=Cropname_FAO(2:end);
    Cropname_monfreda=Cropname_monfreda(2:end);
    itemcode=itemcode(2:end);
end




    if ~iscell(InputNames)
        InputNameList{1}=InputNames;
    else
        InputNameList=InputNames;
    end


for j=1:length(InputNameList)
    ThisName=InputNameList{j};
    ii=strmatch(ThisName,Cropname_FAO);
    if isempty(ii)
        error(['No match for ' ThisName]);
    end
    if length(ii)>1
        error(['Multiple matches for ' ThisName]);
    end
    OutputNames(j)=Cropname_monfreda(ii);
    GroupNames(j)=Group(ii);
    itemcodes(j)=str2num(itemcode{ii});
end

