a=whos;
disp( '%%%Local Vars%%%')


for j=1:length(a);
   
   if strcmp(a(j).class,'double')  & prod(a(j).size)==1
      disp([ a(j).name ' = ' num2str( eval(a(j).name)) ]);
   else
      disp([ a(j).name '  class ''' a(j).class ''' size  ' num2str(a(j).size) ...
             ]);
   end
end
%     a=whos('global')

%     disp( '%%%Global Vars%%%')
%for j=1:length(a);
%   
%   if strcmp(a(j).class,'double')  & prod(a(j).size)==1
%      disp([ a(j).name ' = ' num2str( eval(a(j).name)) ]);
%   else
%      disp([ a(j).name '  class ''' a(j).class ''' size  ' num2str(a(j).size) ...
%             ]);
%   end
%end
 
