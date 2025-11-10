## From Alex

##%%capture
##%pip install rioxarray cartopy fiona rio_cogeo pyogrio

import os
import sys
import shutil
import numpy as np
import pandas as pd
import xarray as xr
import rioxarray as rio
import seaborn as sns
import geopandas as gpd
import rasterio
import matplotlib.pyplot as plt
import matplotlib.patheffects as PathEffects
from matplotlib.patches import Polygon
import matplotlib.patches as mpatches
import matplotlib.colors as mcolors
from matplotlib.colors import Normalize, BoundaryNorm, ListedColormap, LinearSegmentedColormap
import matplotlib.font_manager as fm
import cartopy.crs as ccrs
import cartopy
import cartopy.feature as cfeature
import configparser

sys.path.insert(0,'utils')
import colab_plotting_utils as plotting_utils
import colab_raster_utils as raster_utils
import vector_utils as vector_utils

plotting_utils.get_drawdown_fonts()

admin_boundaries_utils = plotting_utils.get_gadm_boundaries_robinson()

## Input Parameters
##MAPS_DIR = 'mapstesting'

##input_tif_path = 'inputfiles/TreeCover2000_pixelfractionperyear_5min.tif' ## can change path here
## takes around 5ish mins to run
## map params
##map_filename = 'TestColabContinousRaster'
##cmap = plt.colormaps.get_cmap('Greens')
##cbar_units = '% tree cover'
##extend_cbar = 'neither'

config = configparser.ConfigParser()
config.read('mapconfig.ini')
MAPS_DIR=config.get('MapConstants','MAPS_DIR')
input_tif_path=config.get('MapConstants','input_tif_path')
map_filename=config.get('MapConstants','map_filename')
cmapname=config.get('MapConstants','cmapname')
cbar_units=config.get('MapConstants','cbar_units')
extend_cbar=config.get('MapConstants','extend_cbar')
caxismax=config.getfloat('MapConstants','caxismax')
caxismin=config.getfloat('MapConstants','caxismin')
print(caxismax)
print(caxismin)

cmap = plt.colormaps.get_cmap(cmapname)

input_tif_pathold = 'inputfiles/TreeCover2000_pixelfractionperyear_5min.tif'
print(input_tif_pathold)
print(input_tif_path)

## IF oceans are NOT set to NaN, run this code block (comment out block if oceans ARE set to NaN)
## get data
da = xr.open_dataarray(input_tif_path, engine='rasterio')
## mask oceans if not set to NaN
masked_da = raster_utils.mask_oceans(da)
masked_da2d = masked_da.squeeze('band', drop=True)
# reproject to robinson for plotting
da2d_robinson = masked_da2d.rio.reproject('ESRI:54030')
print(da2d_robinson.rio.crs)

# ## IF oceans are set to NaN, run this code block (uncomment the left most number sign for next 4 lines and comment out above block)
# da2d = plotting_utils.prep_raster_4plotting(input_tif_path)
# # reproject to robinson for plotting
# da2d_robinson = masked_da2d.rio.reproject('ESRI:54030')
# print(da2d_robinson.rio.crs)

# these are now passed in
## usually plot the data_min to the 99th percentile value of data
##data_min, data_max, data_percile = raster_utils.get_summary_stats(da2d_robinson, 100)

data_min=caxismin
data_max=caxismax


        #extend=extend_cbar #, # 'neither', 'min', 'max', 'both'


## plot MAP ONLY
plotting_utils.plot_global_raster_dark(
    data_array=da2d_robinson,
    arr_cmap=cmap,
    data_min=caxismin,
    data_max=caxismax, # or can set to data_percile
    extend_cbar=extend_cbar, # TODO update func to remove this param if include_legend=False
    admin_boundaries=admin_boundaries_utils,
    map_output_dir=MAPS_DIR,
    map_filename=map_filename + '_maponly',
    cbar_title=cbar_units,
    map_title=None, ## must be set to None for map only
    include_legend=False ## must be set to False for map only
)

print('after map')
plotting_utils.create_continuous_colorbar_light(
    cmap=cmap,
    vmin=int(data_min),
    vmax=100,
    cbar_title=cbar_units,
    legend_filename=map_filename,
    extend_cbar=extend_cbar,
    output_dir=MAPS_DIR
)

print('after 1st legend')
plotting_utils.create_continuous_colorbar_dark(
    cmap=cmap,
    vmin=int(data_min),
    vmax=100,
    cbar_title=cbar_units,
    legend_filename=map_filename,
    extend_cbar=extend_cbar,
    output_dir=MAPS_DIR
)

print('hey i am done')