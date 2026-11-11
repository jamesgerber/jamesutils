function [OutputData]=MakeAlexStyleFigs(mapdata,PS);
% Use pd-create-maps (by Alex Sweeney) to make figures
%
% Syntax: OutputData]=MakeAlexStyleFigs(mapdata,PS)
%    raster = global geotiff, 4320 x 2160 is expected
%    PS = parameter structure, must have the following fields:
%
% Mandatory:
%  PS.MAPS_DIR= maps directory
%  PS.map_filename = 
%  PS.cmap_string
%  PS.data_min='0';
%  PS.data_max='0.5';
%  PS.cbar_title='Fraction of land suitable for reforestation';
%  PS.extend_cbar='max'; %'neither', 'min', 'max', 'both'
%  PS.cmap_string=string for matplotlib() or finemap.m, or hex codes, or a
% finemap string. 
%
% Optional:
%  PS.DPI - please just don't touch this one
%  PS.logicalinclude - yeah, don't touch this one either
%  PS.
% Disconnected:
%  PS.cbar_units
%
%  cmap_string can be a matplotlib string, a finemap string, or a cell
%  array of hex codes.wd
%
%
%    
%

% logicalinclude - note, not passed to python
%
% this will look for a file
% % source "$HOME/anaconda3/etc/profile.d/conda.sh"
% % conda activate plotting2
% % cd ~/source/pd-create-maps
% % /Users/jsgerber/.conda/envs/plotting2/bin/python  ~/source/jamesutils/pythonmatlab/CreateMapsParameterizedNew.py


%
% extend=extend_cbar #, # 'neither', 'min', 'max', 'both'
% cmapname see here
% https://matplotlib.org/stable/users/explain/colors/colormaps.html
% plot_color_gradients('Sequential',
%                      ['Greys', 'Purples', 'Blues', 'Greens', 'Oranges', 'Reds',
%                       'YlOrBr', 'YlOrRd', 'OrRd', 'PuRd', 'RdPu', 'BuPu',
%                       'GnBu', 'PuBu', 'YlGnBu', 'PuBuGn', 'BuGn', 'YlGn'])
%
%                       ['binary', 'gist_yarg', 'gist_gray', 'gray', 'bone',
%                       'pink', 'spring', 'summer', 'autumn', 'winter', 'cool',
%                       'Wistia', 'hot', 'afmhot', 'gist_heat', 'copper']);
%
% can also be of the form
% ['#F2FAEB', '#DCF0C7', '#C5E6A2', '#AFDD7E', '#98D35A', '#82C936', '#6BA52C', '#538122', '#385617']


if nargin==0
    help(mfilename)
    return
end

if isnumeric(mapdata)
    raster=mapdata;
    VectorFlag=0;

    if numel(raster) > 4320*2160*4
        warning('resolution too high, exiting')
        return
    end


elseif ischar(mapdata)
    csvfilename=mapdata;
    VectorFlag=1;
else
    error('need mapdata to be raster or filename to a csv');
end




% various tests/fixes on PS fields:
% no '~' in MAPS_DIR
% no numbers, need only strings

if ~isempty(strfind(PS.MAPS_DIR, '~'))
    warning('replacing ~ with full path name (python does not like ~)');

    % two possible cases:  '~username' or '~' resolves to /Users/username
    username=getenv('USER');
    str=PS.MAPS_DIR;
    % catch first case
    str=strrep(str,['~' username],['/Users/' username]);
    % catch second case
    str=strrep(str,'~/' ,['/Users/' username '/']);
    PS.MAPS_DIR=str;
end

% now make sure that no one passed in a directory name starting with "."
% just error it out ... no way to know what user actually intended.

if isequal(PS.MAPS_DIR(1),'.')
    error(' please no relative directory names, they make python unhappy ')
end

if isnumeric(PS.data_max)
    warning('make data_max a string if you want to control precision')
    PS.data_max=num2str(PS.data_max);
end

if isnumeric(PS.data_min)
    warning('make data_max a string if you want to control precision')
    PS.data_min=num2str(PS.data_min);
end

if VectorFlag==0
    % write out .tif file
    mkdir([PS.MAPS_DIR filesep 'datatifs']);
    globalarray2geotiff(raster,[PS.MAPS_DIR filesep 'datatifs' filesep PS.map_filename])
end


workingdir=[getenv("TEMP_DIR") 'pythontempfiles/'];
if ~exist(workingdir, 'dir')
    mkdir(workingdir)
end
configpath=[workingdir 'mapconfig.ini'];
setenv("MAPCONFIG_PATH", configpath)


if VectorFlag==0
    if isfield(PS,'logicalinclude')
        logicalinclude=PS.logicalinclude;
        tempraster=raster;
        tempraster(~logicalinclude)=nan;
    else
        tempraster=raster;
    end
    if islogical(tempraster)
        tempraster=single(tempraster);
    end


end

if ~isfield(PS,'DPI')
    PS.DPI='600';
end


if ~isfield(PS,'plotdatacolumn')
    PS.plotdatacolumn='plotdata';
end


if VectorFlag==0

    % write out intermediate .tif file
    globalarray2geotiff(tempraster,[workingdir 'tempraster.tif']);
    PS.input_tif_filename=[workingdir 'tempraster.tif'];
end

% make config.ini file

%units=PS.cbar_units;
%units=strrep(units,'%%','%'); % in case someone sends in %%, break it
%units=strrep(units,'%','%%'); % in case someone sends in %%, break it

cbar_title=PS.cbar_title;
cbar_title=strrep(cbar_title,'%%','%'); % in case someone sends in %%, break it
cbar_title=strrep(cbar_title,'%','%%'); % in case someone sends in %%, break it

if isfield(PS,'caxismin');
    PS.data_min=PS.caxismin;
end
if isfield(PS,'caxismax');
    PS.data_max=PS.caxismax;
end
if isfield(PS,'cmapname');
    PS.cmap_string=PS.cmapname;
end


fid=fopen([workingdir 'mapconfig.ini'],'w');
fprintf(fid,'\n');
fprintf(fid,'[MapConstants]\n')
fprintf(fid,'MAPS_DIR = %s\n', PS.MAPS_DIR);
fprintf(fid,'map_filename = %s\n', PS.map_filename);
fprintf(fid,'data_min = %s\n', PS.data_min);
fprintf(fid,'data_max = %s\n', PS.data_max);
fprintf(fid,'cbar_title = %s\n',cbar_title) ;
%fprintf(fid,'cbar_units = %s\n',units) ;
fprintf(fid,'extend_cbar = %s\n', PS.extend_cbar);
fprintf(fid,'DPI = %s\n', PS.DPI);
fprintf(fid,'plotdatacolumn = %s\n', PS.plotdatacolumn)

if isfield(PS,'data_center')
    fprintf(fid,'data_center = %s\n', PS.data_center);
end

% cmap_string: expect a list of hex codes.
if iscell(PS.cmap_string)
    cmap_list = cellstr(PS.cmap_string);
else % not a hex list -> treat as a colormap name for python fetch
    % TODO Talk to Jamie about a shared matlab wrapper for my python function tho maybe thats a bad idea...
    cmapname = char(PS.cmap_string);
    pyrun("import importlib, colormap_utils")
    [cmap, ~] = pyrun( ...
        sprintf(['from colormap_utils import fetch_cmap; ', ...
                 'cmap_hex, cmap_rgb = fetch_cmap(''%s'')'], cmapname), ...
        ["cmap_hex", "cmap_rgb"]);
    cmap = cellstr(string(cmap));
    N = length(cmap);
    % lets have 20 RGBs
    Nskip = ceil(N/20);

    ShortMap = cmap(1:Nskip:end,:);
    PS.cmap_string = ShortMap;
    cmap_list = ShortMap;
end
fprintf(fid, 'cmap_string = %s\n', strjoin(cmap_list, ', '));

if VectorFlag==1
    fprintf(fid,'input_csv_filename = %s\n', PS.input_csv_filename);
else
    fprintf(fid,'input_tif_filename = %s\n', PS.input_tif_filename);
end



fclose(fid);

if VectorFlag==1
    script='CreateNewStyleMapsFromWrapper_vector.py';
else
    script='CreateNewStyleMapsFromWrapper_raster.py';
end
pyrunfile([getenv("JAMES_UTILS_PATH") '/pythonmatlab/' script])

stack=dbstack;

if ~isempty(stack)
    callingfilename=stack(end).name;
else
    callingfilename='base';
end

if VectorFlag==0
OutputData.raster=raster;

end
OutputData.PS=PS;
OutputData.callingfunction=callingfilename;
OutputData.mapcreated=string(datetime("now"));


% now play around with .pngs and create a version with legend

[atransp,map,alphatransp]=imread([PS.MAPS_DIR filesep PS.map_filename '_transparent.png']);
[aleglight,map,alphaleglight]=imread([PS.MAPS_DIR filesep PS.map_filename '_legend_light.png']);
%[alegdark,map,alphalegdark]=imread([PS.MAPS_DIR filesep PS.map_filename '_legend_dark.png']);


%now copy light legend onto alpha transp

ii=(-1455:1454)+7762/2;
jj=(-604:0)+3947;

nr = min(numel(jj), size(aleglight,1)-80);   % rows from 81:end
nc = min(numel(ii), size(aleglight,2));      % cols from 81:end

jj = jj(1:nr);                               % crop the index ranges to fit
ii = ii(1:nc);

anew(jj,ii,:) = aleglight(81:80+nr,:,:);
alphtranspnew(jj,ii) = alphaleglight(81:80+nr,:,:);

imwrite(anew,[PS.MAPS_DIR filesep PS.map_filename '_map_legend_NOT_FOR_KEYNOTE.png'],'Alpha',alphtranspnew);
