function out=callpersonalpreferences(in);
%CALLPERSONALPREFERENCES  - gateway & defaults for personalpreferences
%
%SYNTAX
%out=callpersonalpreferences(in) - set out to personal preference
%specified by string in. If something goes wrong, give helpful feedback.



ListOfPreferences={'printingres','GraphicsFileType','oceancolor',...
    'nodatacolor','latlongcolor','maxnumfigsNSG','texinterpreter'};
%% if called with no arguments, tell user what defaults are
if nargin==0
    for j=1:length(ListOfPreferences)
        
        val=callpersonalpreferences(ListOfPreferences{j});
        
        if isstr(val)
        disp(sprintf('%20s ,     ''%s'' ) ',...
            ['personalpreferences(''' ListOfPreferences{j} ''''  ],...
            val));
        else
        disp(sprintf('%20s ,      [%s])',...
            ['personalpreferences(''' ListOfPreferences{j} '''' ],...
            num2str(val)));
        end
    end
    return
end

    



%% OutputFig
printingres='-r300';
GraphicsFileType='-dpng';% '-djpg' ; '-dtiff';


%% NiceSurf / NiceSurfGeneral
 oceancolor=[0.3765 0.4824 0.5451]; % old color: 'emblue';
    nodatacolor=[.74 .74 .74]; % old color: 'gray';
latlongcolor=[.3 .3 .3];
maxnumfigsNSG=0;
texinterpreter='none';  %or 'latex'


try
    out=personalpreferences(in);
    return
catch
disp('Did not have successful call to personal preferences ... calling default')

disp(' You probably need to copy personalpreferencestemplate.m to ~/Documents/MATLAB !')
S=which('startup');
S=S(1:end-9);
R=which('personalpreferencestemplate.m');
disp(['Please execute in matlab command window: '])
disp(['!cp ' R '  ' S 'personalpreferences.m ']);

eval(['out=' in ';']);


end
