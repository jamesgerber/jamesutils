% saveEnvironment - most important set of files in editor
%  https://www.mathworks.com/matlabcentral/answers/239151-any-way-to-get-2015a-working-with-two-environments
%
% see also:  loadEnvironment
%
%
docArray = matlab.desktop.editor.getAll;
fNames = cell(1,length(docArray));
for fIdx = 1:length(docArray)
    fNames{fIdx} = docArray(fIdx).Filename;
end

savepath=path
wd=pwd;
historypath = com.mathworks.mlservices.MLCommandHistoryServices.getSessionHistory;




save('WorkingEnvironment.mat','fNames','savepath','wd','historypath')



