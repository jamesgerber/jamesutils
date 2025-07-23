function DisplayStructure(a)
% DISPLAYSTRUCTURE - display the fields of a structure
% 
% SYNTAX
% DisplayStructure(a) - print the fields of the structure a to the screen

list=fieldnames(a);

for j=1:length(list);
    thisname=list{j};
    ThisVal=getfield(a,thisname);
    if length(ThisVal)>1
        ThisVal=ThisVal(1);
        AtEnd='... ';
    else
        AtEnd=' ';
    end
    
    if iscell(ThisVal)
        ThisVal=ThisVal{1};
    end
    
    if isstr(ThisVal)
        dispstr=ThisVal;
    else
        dispstr=num2str(ThisVal);
    end
    
   % disp([ thisname '  ' dispstr AtEnd]);
fprintf('%20s  %8s %10s \n',thisname,dispstr,AtEnd)

end
