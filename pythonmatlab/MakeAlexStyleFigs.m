function [OutputData]=MakeAlexStyleFigs(raster,PS);
% make figs in python
%PS = ParameterStructure
% %PS fields = 
% MAPS_DIR
% input_tif_path
% cbar_units
% extend_cbar
% cmapname
% mapfilename
% logicalinclude
% DPI (default = 600)
%
% extend=extend_cbar #, # 'neither', 'min', 'max', 'both'
% cmapname see here 
% https://matplotlib.org/stable/users/explain/colors/colormaps.html
% plot_color_gradients('Sequential',
%                      ['Greys', 'Purples', 'Blues', 'Greens', 'Oranges', 'Reds',
%                       'YlOrBr', 'YlOrRd', 'OrRd', 'PuRd', 'RdPu', 'BuPu',
%                       'GnBu', 'PuBu', 'YlGnBu', 'PuBuGn', 'BuGn', 'YlGn'])
% 
%                                           ['binary', 'gist_yarg', 'gist_gray', 'gray', 'bone',
%                       'pink', 'spring', 'summer', 'autumn', 'winter', 'cool',
%                       'Wistia', 'hot', 'afmhot', 'gist_heat', 'copper']);

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
    else
        logicalinclude=landmasklogical;
    end

    if ~isfield(PS,'DPI')
        PS.DPI=600;
    end

    tempraster=raster;
    tempraster(~logicalinclude)=nan;
        

    % write out intermediate .tif file
    globalarray2geotiff(tempraster,[workingdir 'tempraster.tif']);
    PS.input_tif_path=[workingdir 'tempraster.tif'];

    % make config.ini file

    units=PS.cbar_units;
    units=strrep(units,'%%','%'); % in case someone sends in %%, break it
    units=strrep(units,'%','%%'); % in case someone sends in %%, break it




    fid=fopen('mapconfig.ini','w');
    fprintf(fid,'\n');
    fprintf(fid,'[MapConstants]\n')
    fprintf(fid,'MAPS_DIR = %s\n', PS.MAPS_DIR);
    fprintf(fid,'input_tif_path = %s\n', PS.input_tif_path);
    fprintf(fid,'cbar_units = %s\n',units) ;
    fprintf(fid,'extend_cbar = %s\n', PS.extend_cbar);
    fprintf(fid,'map_filename = %s\n', PS.map_filename);
    fprintf(fid,'cmapname = %s\n', PS.cmapname);
    fprintf(fid,'caxismax = %s\n', PS.caxismax);
    fprintf(fid,'caxismin = %s\n', PS.caxismin);
    fprintf(fid,'DPI = %s\n', PS.DPI);

    fclose(fid)

    !/opt/miniconda3/bin/python ~/source/jamesutils/pythonmatlab/CreateMapsParameterized.py



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

%end
cd(wd)

%finder([PS.MAPS_DIR 'SavedFileData_' PS.map_filename])