% saveEnvironment - most important set of files in editor
%  https://www.mathworks.com/matlabcentral/answers/239151-any-way-to-get-2015a-working-with-two-environments
%
% see also:  loadEnvironment
%
%



load('WorkingEnvironment.mat','fNames','savepath','wd','historypath')




for fIdx = 1:length(fNames)
    matlab.desktop.editor.openDocument(fNames{fIdx});
end