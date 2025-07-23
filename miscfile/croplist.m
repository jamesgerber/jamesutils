function CropList=CropList(DirString,flag);
% CropList - return a list of crops
%
% SYNTAX
% CropList=CropList(DirString,flag) - return a cell array of the names of
% all the crop gridsfound in the specified directory in
% <iddstring>/Crops2000/crops.  If flag is 'limited', don't include rainfed
% or income-limited crops; if flag is 'all', include all.  If flag is
% unspecified, default is 'limited'.

if nargin  ==0
    DirString='';
end

if nargin <2
    flag='limited';
end



a=dir([iddstring '/Crops2000/crops/*' DirString '*_5min.nc*']);


switch flag
    case 'limited'
        
        b=dir([iddstring '/Crops2000/crops/*' 'RF' '*_5min.nc*']);
        c=dir([iddstring '/Crops2000/crops/*' 'ncome' '*_5min.nc*']);
        
        for j=1:length(a);
            anames{j}=a(j).name;
        end
        
        % remove the RF and income-lmited crops
        removelist=[];
        for j=1:length(b)
            thisname=b(j).name;
            ii=strmatch(thisname,anames,'exact');
            removelist=[removelist ii];
        end
        for j=1:length(c)
            thisname=c(j).name;
            ii=strmatch(thisname,anames,'exact');
            removelist=[removelist ii];
        end
        
        keeplist=setdiff(1:length(a), removelist);
        
        a=a(keeplist);
    case 'all'
        disp(['warning ... keeping crops such as rainfedmaize']);
    otherwise
        error(['don''t know this syntax']);
end


for j=1:length(a)
    CropList{j}=strrep(a(j).name,'_5min.nc','');
end
