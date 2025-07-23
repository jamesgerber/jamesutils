a=whos;
for j=1:length(a);
   switch a(j).class;
    case 'double'
     val=eval(a(j).name);
     if isempty(val)
        val='[]';
     end
        
       disp([a(j).name ' = ' num2str(val(1))]);
    otherwise
     disp([a(j).name ' of class ' a(j).class ]);
   end
end
