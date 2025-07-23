function ChangeProjection(varargin);
% ChangeProjection - Change projection of map. Helper for IonESurf.
%
if nargin==0
    help(mfilename);
    return
end

InputFlag=varargin{1};


key=maps('idlist');
key(19,:)=[];
key(62,:)=[];
key(65,:)=[];
descript=maps('namelist');
MapsToIncludeList=[1:72];
CallbackString=['projection|' descript(MapsToIncludeList(1),:)];
for j=2:length(MapsToIncludeList);
    descript(MapsToIncludeList(j),:);
    if ~(strcmp(descript(MapsToIncludeList(j),:),'Globe                              ')...
            ||strcmp(descript(MapsToIncludeList(j),:),'Universal Transverse Mercator (UTM)')...
            ||strcmp(descript(MapsToIncludeList(j),:),'Universal Polar Stereographic      '))
        CallbackString=[CallbackString '|' descript(MapsToIncludeList(j),:) ];
    end
end

switch(InputFlag)
    case 'Initialize'
        uicontrol('style','popupmenu','String',CallbackString,'Callback', ...
            'ChangeProjection(''ChangeProjectionCallback'')','Position',[5,320,120,25]);
        
    case 'ChangeProjectionCallback'
        
        Val=get(gcbo,'Value');  %Val will be the number
        %corresponding to the string of the uicontrol.  REmember that we
        %need to subtract 1.
        if Val==1
            %            'user touched the control but didn''t specify a projection'
        else
            Val=Val-1;  %now Val indexes into key and descript
            mapproj=getm(gca,'mapproj');
            if (strcmp(mapproj,'cassinistd')||strcmp(mapproj,'tranmerc')||strcmp(mapproj,'polycon')||strcmp(mapproj,'polyconstd')...
                    ||strcmp(mapproj,'gnomonic')||strcmp(mapproj,'ortho')||strcmp(mapproj,'stereo')||strcmp(mapproj,'vperspec')||strcmp(mapproj,'wiechel'))
                setm(gca,'mapproj','cassini');
            end
            setm(gca,'mapproj',regexprep(key(Val,:), '[^A-Za-z0-9]', ''));
        end
    otherwise
    error(['syntax error in ' mfilename])

end
