function ht=outputtoionefigureconsole(UDS,CountryName,Value,x,y);
% helper function to ionebuttondownfunctions

%% now set text in the console


% first delete old text
h=findobj('Tag','IonEConsoleText');
delete(h);

hc=UDS.ConsoleAxisHandle;
axes(hc)


%now new text

set(hc,'xlim',[0 1]);
set(hc,'ylim',[0 1]);
ht=text(0.25,.5,['Country=' CountryName]);
set(ht,'Tag','IonEConsoleText');
ht=text(0.5,.5,['Value = ' num2str(Value)]);
set(ht,'Tag','IonEConsoleText');
ht=text(0.75,0.5,{['Lat = ' num2str(y)],['Lon = ' num2str(x)]});
set(ht,'Tag','IonEConsoleText');
axes(UDS.DataAxisHandle);  %make data axis handle current

end