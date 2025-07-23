function list=expandIntegerList(textstring);
% expandNumericalList - turn a formatted list into a list of numbers
%
%   1:34, 23,26, 2:8


textstring=strrep(textstring,'"','');

iicomma= find(textstring==',');

iicomma(end+1)=numel(textstring)+1;


individualparts{1}= textstring(1:iicomma(1)-1);

for j=1:numel(iicomma)-1;
    individualparts{end+1}= textstring(iicomma(j)+1 : iicomma(j+1)-1)
end



list=[];
for j=1:numel(individualparts)
    
    str=individualparts{j};
    iicolon=find(str==':');

    if isempty(iicolon)
        
        newnumbers=str2num(str);
    else
        
        newnumbers=str2num(str(1:iicolon-1)): str2num(str(iicolon+1:end));
    end
    
    
    list=[list newnumbers(:)'];
end