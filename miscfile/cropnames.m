function [names,FAOnames,FAOnums]=cropnames(j)
% CROPNAMES - get a list of all Monfreda crop names
%
% SYNTAX
% names=cropnames - set name to a one-column cell array of all Monfreda
% [names,FAOnames,FAOnums]=cropnames - set name to a one-column cell array of all Monfreda
% crop names
% name=cropnames(j) - get the crop name at index j

fid=fopen([iddstring 'misc/Reconcile_Monfreda_FAO_cropnames.txt'],'r');
C = textscan(fid,'%s%s%s%s','Delimiter',tab,'HeaderLines',1);
fclose(fid);

nums_unsort=str2double(C{1});
mnames=C{2};
faonames_unsort=C{3};
group_unsort=C{4};

ii=strmatch('coir',mnames);
mnames=mnames([1:ii-1   ii+1:length(mnames)]);
faonames_unsort=faonames_unsort([1:ii-1   ii+1:length(faonames_unsort)]);
nums_unsort=nums_unsort([1:ii-1   ii+1:length(nums_unsort)]);

ii=strmatch('gums',mnames);
mnames=mnames([1:ii-1   ii+1:length(mnames)]);
faonames_unsort=faonames_unsort([1:ii-1   ii+1:length(faonames_unsort)]);
nums_unsort=nums_unsort([1:ii-1   ii+1:length(nums_unsort)]);

ii=strmatch('popcorn',mnames);
mnames=mnames([1:ii-1   ii+1:length(mnames)]);
faonames_unsort=faonames_unsort([1:ii-1   ii+1:length(faonames_unsort)]);
nums_unsort=nums_unsort([1:ii-1   ii+1:length(nums_unsort)]);





names=mnames;
FAOnames=faonames_unsort;
FAOnums=nums_unsort;

if nargin==1
    names=names(j);
    FAOnames=FAOnames(j);
end
