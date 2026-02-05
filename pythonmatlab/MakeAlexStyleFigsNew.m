function [OutputData]=MakeAlexStyleFigs(raster,PS);
% Use pd-create-maps (by Alex Sweeney) to make figures
%
%
% This is a new version of this file ... this time I'm approaching this
% with a better understanding of conda environments and python in general.
%
%
%PS = ParameterStructure
% %PS fields =

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
wd=pwd;

workingdir='/Users/jsgerber/temp/pythontempfiles/';
try
    cd(workingdir)
catch
    mkdir(workingdir)
    cd(workingdir)
end

%try


if isfield(PS,'logicalinclude')
    logicalinclude=PS.logicalinclude;
    tempraster=raster;
    tempraster(~logicalinclude)=nan;
else
    tempraster=raster;
end

if ~isfield(PS,'DPI')
    PS.DPI='600';
end




% write out intermediate .tif file
globalarray2geotiff(tempraster,[workingdir 'tempraster.tif']);
PS.input_tif_filename=[workingdir 'tempraster.tif'];

% make config.ini file

units=PS.cbar_units;
units=strrep(units,'%%','%'); % in case someone sends in %%, break it
units=strrep(units,'%','%%'); % in case someone sends in %%, break it

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
fprintf(fid,'input_tif_filename = %s\n', PS.input_tif_filename);
fprintf(fid,'MAPS_DIR = %s\n', PS.MAPS_DIR);
fprintf(fid,'map_filename = %s\n', PS.map_filename);
fprintf(fid,'data_min = %s\n', PS.data_min);
fprintf(fid,'data_max = %s\n', PS.data_max);
fprintf(fid,'cbar_title = %s\n',cbar_title) ;
fprintf(fid,'cbar_units = %s\n',units) ;
fprintf(fid,'extend_cbar = %s\n', PS.extend_cbar);
fprintf(fid,'DPI = %s\n', PS.DPI);

if iscell(PS.cmap_string)
    fprintf(fid,'cmap_string = %s',PS.cmap_string{1})
    for j=2:numel(PS.cmap_string);
        fprintf(fid,', %s ',PS.cmap_string{j}) ;
    end
    fprintf(fid,'\n')
else
    fprintf(fid,'cmap_string = %s',PS.cmap_string)


end

fclose(fid)

cd ~/source/pd-create-maps/

!/Users/jsgerber/.conda/envs/plotting2/bin/python  ~/source/jamesutils/pythonmatlab/CreateMapsParameterizedNew_copyAlex.py

cd(wd)

stack=dbstack;

if ~isempty(stack)
    callingfilename=stack(end).name;
else
    callingfilename='base';
end


OutputData.raster=raster;
OutputData.PS=PS;
OutputData.callingfunction=callingfilename;
OutputData.mapcreated=datestr(now);


cd(wd)

