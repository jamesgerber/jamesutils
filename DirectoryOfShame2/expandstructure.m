function list=ExpandStructure(a)
% EXPANDSTRUCTURE - put all fields in a structure (or vector of structures) into workspace
%
% SYNTAX
% ExpandStructure(a) - copy all fields of structure a into workspace
% variables.
%
% Note: doesn't handle vectors of structures where structures have
% vector-valued fields
list=fieldnames(a);

if length(a)==1
    for j=1:length(list);
        thisname=list{j};
        assignin('caller',thisname,getfield(a,thisname));
    end
else
    for j=1:length(list);
        thisname=list{j};
        assignin('caller',thisname,eval([ '[a.' thisname '];']));
    end
end


