function DSNew=ColumnStructure(DS);
%ColumnStructure - make all vectors in a structure into columns.


a=fieldnames(DS);


DSNew=DS;   %Cheesy approach ... make DSNew exist so call to  setfield
%doesn't crash the first time through below.

for j=1:length(a);
    ThisField=getfield(DS,a{j});
    if length(ThisField)>1 & ~ischar(ThisField) %allow for scalar fields to go untouched, and doesn't mess with character strings
        NewField=ThisField(:);
    else
        NewField=ThisField;
    end
    DSNew=setfield(DSNew,a{j},NewField);
end
