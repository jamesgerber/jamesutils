function DataToDrawdownFigures(raster,NSS,filenameroot,outputfolder,regionlist);
% DataToDrawdownFigures - make a bunch of figures, save output
%
%  DataToDrawdownFigures(raster,NSS,filenameroot,outputfolder,regionlist)
%
% Example
% DataToDrawdownFigures(area2020*100,NSS,'RiceCultivationArea','finalfigsanddata/',{'SEAsia'});
%
%  DataToDrawdownFigures(area2020*100,'','RiceCultivationArea','finalfigsanddata/','');
%   without 2nd argument, just output the data and return
%
%  if outputfolder is empty, return doing nothing (this allows a hack to
%  run through a script without actually doing the outputs)

%set(0,'DefaultFigureVisible','off')  - this was an attempt to have the matlab figures
% not steal the focus.  Sadly, it doesn't work.
if isempty(outputfolder)
    disp(['outputfolder argument is empty, returning']);
    return
end

if numel(find(outputfolder=='/'))==0
    if exist(outputfolder)==7
        disp(['preparing to write to ' outputfolder])
    else
        error('seems like outputfolder and filenameroot reversed. filenameroot comes first.');
    end
end

if nargin<4
    outputfolder='figures/';
end
%% I wrote these lines, they worked for about a year, then google drive problems started:
% mkdir(outputfolder);
% mkdir([outputfolder '/data_geotiff']);
% mkdir([outputfolder '/FigsStyledFor2026/']);
% mkdir([outputfolder '/data_matlabfigure']);
% mkdir([outputfolder '/figs_blackbackground']);
% mkdir([outputfolder '/figs_whitebackground']);
% mkdir([outputfolder '/figs_whitebackground_notitle']);
% mkdir([outputfolder '/figs_blackbackground_notitle']);
% mkdir([outputfolder '/figs_blackbackground_notitlenounits']);
% mkdir([outputfolder '/figs_whitebackground_notitlenounits']);
% mkdir([outputfolder '/regionalfigs'])
% mkdir([outputfolder '/regionalfigs/figs_blackbackground']);
% mkdir([outputfolder '/regionalfigs/figs_whitebackground']);
% mkdir([outputfolder '/regionalfigs/figs_whitebackground_notitle']);
% mkdir([outputfolder '/regionalfigs/figs_blackbackground_notitle']);
% mkdir([outputfolder '/regionalfigs/figs_blackbackground_notitlenounits']);
% mkdir([outputfolder '/regionalfigs/figs_whitebackground_notitlenounits']);

% used Claude to rewrite 
% prompt:  please rewrite these lines of matlab code to have a unix call  instead so unix([' mkdir ' outputfolder ]).   
% mkdir(outputfolder); (etc)

unix(['mkdir -p "' outputfolder '"']);
unix(['mkdir -p "' outputfolder '/data_geotiff"']);
unix(['mkdir -p "' outputfolder '/FigsStyledFor2026/"']);
unix(['mkdir -p "' outputfolder '/data_matlabfigure"']);
unix(['mkdir -p "' outputfolder '/figs_blackbackground"']);
unix(['mkdir -p "' outputfolder '/figs_whitebackground"']);
unix(['mkdir -p "' outputfolder '/figs_whitebackground_notitle"']);
unix(['mkdir -p "' outputfolder '/figs_blackbackground_notitle"']);
unix(['mkdir -p "' outputfolder '/figs_blackbackground_notitlenounits"']);
unix(['mkdir -p "' outputfolder '/figs_whitebackground_notitlenounits"']);
unix(['mkdir -p "' outputfolder '/regionalfigs"']);
unix(['mkdir -p "' outputfolder '/regionalfigs/figs_blackbackground"']);
unix(['mkdir -p "' outputfolder '/regionalfigs/figs_whitebackground"']);
unix(['mkdir -p "' outputfolder '/regionalfigs/figs_whitebackground_notitle"']);
unix(['mkdir -p "' outputfolder '/regionalfigs/figs_blackbackground_notitle"']);
unix(['mkdir -p "' outputfolder '/regionalfigs/figs_blackbackground_notitlenounits"']);
unix(['mkdir -p "' outputfolder '/regionalfigs/figs_whitebackground_notitlenounits"']);

if nargin<5
    regionlist={};
end

if ~iscell(regionlist)
    regionlist={regionlist};
end

% let's output data in front, then if NSS is empty return

% now save data
extranotes=['produced ' datestr(now) ' in ' pwd ]
globalarray2geotiffwithnodatavalue(raster,[outputfolder '/data_geotiff/' filenameroot '_data.tif']);

if isempty(NSS)
    disp(['NSS is empty, returning after outputting data'])
    return
end


if isfield(NSS,'plotflag')
    if isequal(lower(NSS.plotflag),'off');
        %disp(['plotflag=off, returning'])
        %return
    end
end

% look for figurehandle field in NSS

if isfield(NSS,'figurehandle') & isgraphics(NSS.figurehandle);
    % everything fabulous, let's write to this figure
else
    nsgfig=figure;
    NSS.figurehandle=nsgfig;
end





NSSorig=NSS;

% first a drawdown blackbackground figure with title, units as passed in

if numel(raster)<=prod(2160*4320*4)
% only make this if size is 2.5 minutes or larger

    OS=nsg(raster,NSS);
    OSwb=OS;
    [status,cmdout] = unix(['cp temp.png ' outputfolder '/figs_whitebackground' filesep filenameroot '_WhiteBackground.png'])

    if status==0
        filename=[outputfolder '/figs_blackbackground' filesep filenameroot '_BlackBackground.png'];
        maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png',filename,[1 1 1],1);
    end

    titlestring=''; % need to define for call to python wrappe
    % now remove units
    if isfield(NSS,'title')
        titlestring=NSS.title;
        NSS=rmfield(NSS,'title');
    end
    if isfield(NSS,'Title')
        titlestring=NSS.Title;
        NSS=rmfield(NSS,'Title');
    end
    NSSnotitle=NSS;

    OS=nsg(raster,NSS);
    [status,cmdout] = unix(['cp temp.png ' outputfolder '/figs_whitebackground_notitle' filesep filenameroot '_WhiteBackground_NoTitle.png'])
  if status==0
      filename=[outputfolder '/figs_blackbackground_notitle' filesep filenameroot '_BlackBackground_NoTitle.png'];
      maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png',filename,[1 1 1],1);
  end
    % now remove units
    unitsstring='';
    if isfield(NSS,'units')
        unitsstring=NSS.units;
        NSS=rmfield(NSS,'units');
    end
    if isfield(NSS,'Units')
        unitsstring=NSS.Units;
        NSS=rmfield(NSS,'Units');
    end
    NSSnotitlenounits=NSS;
    OS=nsg(raster,NSS);
    [status,cmdout] = unix(['cp temp.png ' outputfolder '/figs_whitebackground_notitlenounits' filesep filenameroot '_WhiteBackground_NoTitleNoUnits.png'])
    if status==0
        filename=[outputfolder '/figs_blackbackground_notitlenounits' filesep filenameroot '_BlackBackground_NoTitleNoUnits.png'];
        maketransparentoceans_noant_nogridlinesnostates_removeislands('temp.png',filename,[1 1 1],1);
    end
    % let's save data for future matlab figure
    if status==0
    save([outputfolder '/data_matlabfigure/' filenameroot '_figdata'],'raster','NSSorig','regionlist','filenameroot','outputfolder','extranotes');
    end
% now make an "Alex-style" figure

% make Alex style figs:
%mkdir([outputfolder '/FigsStyledFor2026/']);
% fprintf(fid,'[MapConstants]\n')
% fprintf(fid,'input_tif_filename = %s\n', PS.input_tif_filename);
% fprintf(fid,'MAPS_DIR = %s\n', PS.MAPS_DIR);
% fprintf(fid,'map_filename = %s\n', PS.map_filename);
% fprintf(fid,'data_min = %s\n', PS.data_min);
% fprintf(fid,'data_max = %s\n', PS.data_max);
% fprintf(fid,'cbar_title = %s\n',cbar_title) ;
% fprintf(fid,'cbar_units = %s\n',units) ;
% fprintf(fid,'extend_cbar = %s\n', PS.extend_cbar);
% fprintf(fid,'DPI = %s\n', PS.DPI);

%need to translate output for panoply triangles into 

if isfield(OS,'panoplytrianglehandlepatches')
    ii=OS.panoplytrianglehandlepatches>0;
else
    ii=[0 0];
end

if ii(1)
    if ii(2)
        extend_cbar='both';
    else
        extend_cbar='min';
    end
else
    if ii(2)
        extend_cbar='max';
    else
        extend_cbar='neither';
    end
end

% what is full directory?
% this code makes sure there's a full directory listing for this next part.
switch outputfolder(1:2)
    case '~/'
        fullMAPS_DIRstart=['/Users/' getenv('username') outputfolder(2:end)];
    case '/U'
        fullMAPS_DIRstart=[outputfolder];
    otherwise
        fullMAPS_DIRstart=[pwd filesep outputfolder];
end

clear PS
PS.MAPS_DIR=[fullMAPS_DIRstart '/FigsStyledFor2026/'];
PS.map_filename=filenameroot;
PS.data_min=num2str(OS.coloraxis(1));
PS.data_max=num2str(OS.coloraxis(2));
PS.cbar_title=titlestring;
PS.cbar_units=unitsstring;
PS.extend_cbar=extend_cbar;

% now the tricky part ... the colormap

if isfield(NSS,'hexmap')
    PS.cmap_string=NSS.hexmap;
else

    cmap=OS.cmap_final;
    N=length(cmap);
    if N > 200
        NewMap=cmap(4:end-3,1:3);
    end

    % lets ahve 20 RGBs
    Nskip=ceil(N/20);


    ShortMap=NewMap(1:Nskip:end,:);

    for j=1:length(ShortMap)
        RGBlist{j}=rgb2hex(ShortMap(j,:));
    end

    PS.cmap_string=RGBlist;
end

if islogical(raster)
    raster=single(raster);
end


MakeAlexStyleFigsNew(raster,PS);

% End of python wrapper section


    if isfield(NSS,'title')
        NSS=rmfield(NSS,'title');
    end
    if isfield(NSS,'Title')
        NSS=rmfield(NSS,'Title');
    end
    NSSnotitle=NSS;
    % now remove units
    if isfield(NSS,'units')
        NSS=rmfield(NSS,'units');
    end
    if isfield(NSS,'Units')
        NSS=rmfield(NSS,'Units');
    end
    NSSnotitlenounits=NSS;

end

if numel(regionlist)>0
    if ~isempty(regionlist{1})   % in case get passed an empty region
        for j=1:numel(regionlist)
            [outputfilename,DataResolution,PrintResolution,Region]=MakeNiceRegionalFigs(raster,regionlist{j},NSSorig,'temp.png');
            unix(['cp ' outputfilename ' ' outputfolder '/regionalfigs/figs_whitebackground/' filenameroot '_' Region 'WhiteBackground.png'])
            maketransparentOcReg_noant_nogridlinesnostates_removeislands...
                (outputfilename,[outputfolder '/regionalfigs/figs_blackbackground/' filenameroot '_' Region '.png'],[1 1 1],1,Region,PrintResolution,DataResolution);

            [outputfilename,DataResolution,PrintResolution,Region]=MakeNiceRegionalFigs(raster,regionlist{j},NSSnotitle,'temp.png');
            unix(['cp ' outputfilename ' ' outputfolder '/regionalfigs/figs_whitebackground_notitle/' filenameroot '_' Region '_NoTitle_WhiteBackground.png'])
            maketransparentOcReg_noant_nogridlinesnostates_removeislands...
                (outputfilename,[outputfolder '/regionalfigs/figs_blackbackground_notitle/' filenameroot '_' Region '_NoTitle.png'],[1 1 1],1,Region,PrintResolution,DataResolution);

            [outputfilename,DataResolution,PrintResolution,Region]=MakeNiceRegionalFigs(raster,regionlist{j},NSSnotitlenounits,'temp.png');
            unix(['cp ' outputfilename ' ' outputfolder '/regionalfigs/figs_whitebackground_notitlenounits/' filenameroot '_' Region '_NoTitleNoUnits_WhiteBackground.png'])
            maketransparentOcReg_noant_nogridlinesnostates_removeislands...
                (outputfilename,[outputfolder '/regionalfigs/figs_blackbackground_notitlenounits/' filenameroot '_' Region '_NoTitleNoUnits.png'],[1 1 1],1,Region,PrintResolution,DataResolution);
        end
    end
end
%set(0,'DefaultFigureVisible','on') 

commandwindow

