function FileName=outputfig(Hfig,FileName,ResFlag,transparent)
% outputfig - output a figure as a .png
%
% SYNTAX
% outputfig('Force') will force priting w/o querying user.
% outputfig(gcf,'FileName','-r300',1) will make background transparent
% outputfig('Force','FileName')
% outputfig('Force','FileName','-r150')
% outputfig(gcf,'FileName')
%
% outputfig('directoryname/') will force printing w/o querying user and put
% the resulting .png into directory directoryname.  the code looks for the
% '/' at the end of the name.
%
% EXAMPLE
% NSG(testdata);
% OutputFig;
if nargin==0
    Hfig=gcf;
    ForcePlots=0;
end
SaveDirectory=''; % making this blank.  before had './'.  -jsg.  June 2015.

if nargin>0
    if ischar(Hfig)
        switch(Hfig)
            case {'force','Force'}
                ForcePlots=1;
                Hfig=gcf;
                MakeSafe=1;
            case 'Initialize'
                uicontrol('String','OutputFig','Callback', ...
                    'OutputFig(gcf,'''',''-r300'',-1);','position',NextButtonCoords);  
                Hfig=gcf;
                ForcePlots=0;
                return
            otherwise
                % if first entry is a directory name, assume 'force'and put
                % files into directory
                if isequal(Hfig(end),'/');
                    SaveDirectory=Hfig;
                    ForcePlots=1;
                    Hfig=gcf;
                    MakeSafe=1;
                else
                
                    error('don''t know this argument to Hfig')
                end
        end
    else
        ForcePlots=0;
    end
end

if nargin==2
    
    if isequal(FileName(end),filesep)
        InitGuess=get(get(gca,'Title'),'String');
        
        if iscell(InitGuess)
            InitGuess=InitGuess{1};
        end
        
        InitGuess=[FileName makesafestring(InitGuess)];
        MakeSafe=0;
    end
end


if nargin>1
    InitGuess=FileName;
    MakeSafe=0;
else
    InitGuess=get(get(gca,'Title'),'String');
    MakeSafe=1;
    
    if iscell(InitGuess)
        InitGuess=InitGuess{1};
    end
    
    
    
end

if nargin<3
    ResFlagcheck=personalpreferences('printingres');
    if isempty(ResFlagcheck)
        ResFlag='-r300';
    else
        ResFlag=ResFlagcheck;
    end
end

if (nargin>=4&&transparent)
    repeat=1;
    while repeat
    bgc=[rand rand rand];
    colors=colormap;
    tmp(:,1)=closeto(bgc(1),colors(:,1),.05);
    tmp(:,2)=closeto(bgc(2),colors(:,2),.05);
    tmp(:,3)=closeto(bgc(3),colors(:,3),.05);
    repeat=max(sum(tmp,2)==3);
    end
    set(gcf,'InvertHardcopy','off');
end
    

% Is this figure made by IonESurf?  If so, expand the data axis
fud=get(Hfig,'UserData');


if isequal(get(Hfig,'tag'),'IonEFigure')
    storepos=get(fud.DataAxisHandle,'position');
    set(fud.DataAxisHandle,'position',[0.025 .2 0.95 .7])
end

figure(Hfig); %Make sure this figure is on top. 


try
    InitGuess=strrep(InitGuess,' ','');
        
    if MakeSafe==1
        InitGuess=strrep(InitGuess,'.','_');
        InitGuess=strrep(InitGuess,':','_');
        InitGuess=strrep(InitGuess,'/','_');
        InitGuess=strrep(InitGuess,',','_');
        InitGuess=makesafestring(InitGuess);
    end
catch
    InitGuess='Figure';
end

InitGuess=[SaveDirectory InitGuess];


try
    SaveFileType=personalpreferences('GraphicsFileType');
catch
    SaveFileType='-dpng';
end


if ForcePlots==0
    [filename,pathname]=uiputfile('*','Choose File Name',InitGuess);
    FileName=[pathname  filename];
else
    FileName=InitGuess;
end
    
    
HideUI;
ppm=get(gcf,'PaperPositionMode');
set(gcf,'PaperPositionMode','auto');

drawnow;

disp(['Saving ' FileName]);

% try
print(SaveFileType,ResFlag,FileName);
% catch
%    disp(['problem with ' FileName ]);
%    disp([' trying to fix ... assuming some characters dont belong']);
% 
%    ii=findstr(FileName,'/')
% 
%    if length(ii)>1
%        FileName(ii(2:end))='_';
%    end
% 
% end
    
set(Hfig,'PaperPositionMode',ppm);

if isequal(get(Hfig,'tag'),'IonEFigure')
    set(fud.DataAxisHandle,'position',storepos);
end

if (nargin>=4&transparent==1)
    im=imread(FileName);
    transparent=im(:,:,1)==im(1,1,1)&im(:,:,2)==im(1,1,2)&im(:,:,3)==im(1,1,3);
    imwrite(im,FileName,'Alpha',double(~transparent));
end
if (nargin>=4&transparent==-1)
    t=get(gcbf,'UserData');
    if t.transparent
        im=imread(FileName);
        transparent=im(:,:,1)==im(1,1,1)&im(:,:,2)==im(1,1,2)&im(:,:,3)==im(1,1,3);
        imwrite(im,FileName,'Alpha',double(~transparent));
    end
end
    
ShowUI;