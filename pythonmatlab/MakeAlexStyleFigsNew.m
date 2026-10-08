function [OutputData]=MakeAlexStyleFigsNew(mapdata,PS);
% Use pd-create-maps (by Alex Sweeney) to make figures
%
% Syntax: OutputData]=MakeAlexStyleFigsNew(mapdata,PS)
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

if length(findstr('~',PS.MAPS_DIR))>0
    warning('replacing ~ with full path name (python does not like ~)');

    % two possible cases:  '~username' or '~' resolves to /Users/username
    username=getenv('USER');
    str=PS.MAPS_DIR;
    % catch first case
    str=strrep(str,['~' username],['/Users/' username]);
    % catch second case
    str=strrep(str,['~/' ],['/Users/' username '/']);
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

wd=pwd;

workingdir='/Users/jsgerber/temp/pythontempfiles/';
try
    cd(workingdir)
catch
    mkdir(workingdir)
    cd(workingdir)
end

%try


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


fid=fopen('mapconfig.ini','w');
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

if iscell(PS.cmap_string)
    fprintf(fid,'cmap_string = %s',PS.cmap_string{1})
    for j=2:numel(PS.cmap_string);
        fprintf(fid,', %s ',PS.cmap_string{j}) ;
    end
    fprintf(fid,'\n')
else % it's a string.   Need to see if it's matplotlib or finemap.
    validMaps=getMatPlotLibsMaps;
    if any(strcmp(PS.cmap_string, validMaps))
        fprintf(fid,'cmap_string = %s',PS.cmap_string)
    else
        % see if we can get finemap to work

        cmap=finemap(PS.cmap_string,'','');
        ii=round(linspace(1,size(cmap,1),50));
        cmap50=cmap(ii,:);
        for j=1:numel(ii)
            cmap_string{j}=rgb2hex(cmap(ii(j),:));
        end
        PS.cmap_string=cmap_string;

        fprintf(fid,'cmap_string = %s',PS.cmap_string{1})
        for j=2:numel(PS.cmap_string);
            fprintf(fid,', %s ',PS.cmap_string{j}) ;
        end
        fprintf(fid,'\n')
    end

end

if VectorFlag==1
    fprintf(fid,'input_csv_filename = %s\n', PS.input_csv_filename);
else
    fprintf(fid,'input_tif_filename = %s\n', PS.input_tif_filename);
end



fclose(fid)

cd ~/source/pd-create-maps/

if VectorFlag==1
    !/Users/jsgerber/.conda/envs/plotting2/bin/python  ~/source/jamesutils/pythonmatlab/CreateNewStyleMapsFromWrapper_vector.py
else
    !/Users/jsgerber/.conda/envs/plotting2/bin/python  ~/source/jamesutils/pythonmatlab/CreateNewStyleMapsFromWrapper_raster.py
end

cd(wd)

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
OutputData.mapcreated=datestr(now);


% now play around with .pngs and create a version with legend

[atransp,map,alphatransp]=imread([PS.MAPS_DIR filesep PS.map_filename '_transparent.png']);
[aleglight,map,alphaleglight]=imread([PS.MAPS_DIR filesep PS.map_filename '_legend_light.png']);
%[alegdark,map,alphalegdark]=imread([PS.MAPS_DIR filesep PS.map_filename '_legend_dark.png']);


%now copy light legend onto alpha transp

ii=(-1455:1454)+7762/2;
jj=(-604:0)+3947;

anew=atransp;
alphtranspnew=alphatransp;

anew(jj,ii,:)=aleglight(81:end,:,:);
alphtranspnew(jj,ii)=alphaleglight(81:end,:,:);

imwrite(anew,[PS.MAPS_DIR filesep PS.map_filename '_map_legend_NOT_FOR_KEYNOTE.png'],'Alpha',alphtranspnew);

cd(wd)




function validMaps = getMatPlotLibsMaps;
% generated this list with ChatGPT
validMaps =  { ...
    'Accent','Accent_r','Blues','Blues_r','BrBG','BrBG_r','BuGn','BuGn_r', ...
    'BuPu','BuPu_r','CMRmap','CMRmap_r','Dark2','Dark2_r','GnBu','GnBu_r', ...
    'Greens','Greens_r','Greys','Greys_r','OrRd','OrRd_r','Oranges','Oranges_r', ...
    'PRGn','PRGn_r','Paired','Paired_r','Pastel1','Pastel1_r','Pastel2','Pastel2_r', ...
    'PiYG','PiYG_r','PuBu','PuBu_r','PuBuGn','PuBuGn_r','PuOr','PuOr_r', ...
    'PuRd','PuRd_r','Purples','Purples_r','RdBu','RdBu_r','RdGy','RdGy_r', ...
    'RdPu','RdPu_r','RdYlBu','RdYlBu_r','RdYlGn','RdYlGn_r','Reds','Reds_r', ...
    'Set1','Set1_r','Set2','Set2_r','Set3','Set3_r','Spectral','Spectral_r', ...
    'Wistia','Wistia_r','YlGn','YlGn_r','YlGnBu','YlGnBu_r','YlOrBr','YlOrBr_r', ...
    'YlOrRd','YlOrRd_r','afmhot','afmhot_r','autumn','autumn_r','binary','binary_r', ...
    'bone','bone_r','brg','brg_r','bwr','bwr_r','cool','cool_r','coolwarm','coolwarm_r', ...
    'copper','copper_r','cubehelix','cubehelix_r','flag','flag_r','gist_earth','gist_earth_r', ...
    'gist_gray','gist_gray_r','gist_heat','gist_heat_r','gist_ncar','gist_ncar_r', ...
    'gist_rainbow','gist_rainbow_r','gist_stern','gist_stern_r','gist_yarg','gist_yarg_r', ...
    'gnuplot','gnuplot_r','gnuplot2','gnuplot2_r','gray','gray_r','hot','hot_r', ...
    'hsv','hsv_r','inferno','inferno_r','jet','jet_r','magma','magma_r','nipy_spectral','nipy_spectral_r', ...
    'ocean','ocean_r','pink','pink_r','prism','prism_r','rainbow','rainbow_r','seismic','seismic_r', ...
    'spring','spring_r','summer','summer_r','tab10','tab10_r','tab20','tab20_r', ...
    'tab20b','tab20b_r','tab20c','tab20c_r','terrain','terrain_r','turbo','turbo_r', ...
    'twilight','twilight_r','twilight_shifted','twilight_shifted_r','viridis','viridis_r','winter','winter_r' ...
};