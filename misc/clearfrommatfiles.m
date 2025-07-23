function ClearFromMatFiles(VariableName)
% CLEARFROMMATFILES - remove a certain variable name from all matfiles in directory
%
%  This is useful if you have accidentally saved many simulation results with 
% some large file in there by accident. 
 
a=dir('*.mat')
for j=1:length(a);
disp(['cleaning up ' a(j).name '. ' num2str(a(j).bytes) ' bytes.']);
stash a
stash j
load(a(j).name);

clear(VariableName)
%clear SpecStructure
unstash a
unstash j
save(a(j).name);
end
