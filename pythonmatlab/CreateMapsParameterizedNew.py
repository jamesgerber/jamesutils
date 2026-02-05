## From pd-create-maps Jan 23, 2026

## import packages
import os
import sys
import xarray as xr

# next two lines from ChatGPT with prompt about script pausing for windows.
import matplotlib
matplotlib.use('macosx')

import matplotlib.pyplot as plt
import numpy as np
## plotting libraries
import matplotlib.pyplot as plt
import matplotlib.patheffects as PathEffects
from matplotlib.patches import Polygon
import matplotlib.patches as mpatches
import matplotlib.colors as mcolors
from matplotlib.colors import Normalize, BoundaryNorm, ListedColormap, LinearSegmentedColormap, colorConverter

import configparser

# load environment file
from dotenv import load_dotenv
load_dotenv('../../.env.local', verbose=True)

## set working directory to root project folder to import utils
ROOT_DIR = os.path.abspath('/Users/jsgerber/source/pd-create-maps/')
# print(ROOT_DIR)
sys.path.insert(0, ROOT_DIR)

sys.path.append('/Users/jsgerber/source/pd-create-maps/utils/')

print(sys.path)



print('debugging section')
import matplotlib
import numpy
import rasterio
import xarray
import rioxarray
import pyproj

print("matplotlib:", matplotlib.__version__)
print("numpy:", numpy.__version__)
print("rasterio:", rasterio.__version__)
print("xarray:", xarray.__version__)
print("rioxarray:", rioxarray.__version__)
print("pyproj:", pyproj.__version__)

import matplotlib
print(matplotlib.get_backend())
matplotlib.use("macosx")
print(matplotlib.get_backend())
import matplotlib
print(matplotlib.get_backend())
# import utils
import utils.presentation_maps_utils as mapping_utils
import utils.raster_utils as raster_utils
import utils.vector_utils as vector_utils

import colorstring_to_colormap


## set up output directory for maps
MAPS_DIR = '../../maps/'
#print(os.path.abspath(MAPS_DIR)) # sanity check

## robinson code
ROB_CODE = 'ESRI:54030'

## figsize wxh
figsize_w, figsize_h = mapping_utils.set_outfig_size(10000, 5100)

## vector
## e.g. should be grabbing the same as GADM_BOUNDARIES path in above cell
gadm_robinson = mapping_utils.get_gadm_boundaries_robinson()

# ## raster land/ocean IF needed
land_ocean_tif = os.getenv('GADM_RASTER_NOISLANDS_5min_PATH') # 5 min tif (gadml0/Production/gadml0_noislands_simplified1km_5min.tif)
# land_ocean_2d = mapping_utils.prep_ocean_4plotting() ## defaults to 2.5 min






## Here is where Jamie has added code to override some variables above, note that these have been
## put into mapconfig.ini

# variables that have to be configed
#input_tif_filename
# #MAPS_DIR
#map_filename
#cmap_string (a list of strings, can be a matplotlib string or a list of colors in HEX ) see below,
#data_min
#data_max
#cbar_title
#cbar_units
#extend_cbar  can be 'neither' 'max' or 'min', Alex has provided a function 


## define cmap
# pull from a pre-configured one (reminder, see here:  https://matplotlib.org/stable/gallery/color/colormap_reference.html)
cmap = plt.colormaps.get_cmap('Greens') 
# # OR create your own
# cmap_colors = ['#F2FAEB', '#DCF0C7', '#C5E6A2', '#AFDD7E', '#98D35A', '#82C936', '#6BA52C', '#538122', '#385617']
# cmap = LinearSegmentedColormap.from_list('my_custom_cmap', cmap_colors)



map_filename = 'Example_ContinuousRaster'


### note need to turn off "#" for comments so I can use hex codes
config = configparser.ConfigParser(
    comment_prefixes=(';'),
    inline_comment_prefixes=(';')
)

config.read('/Users/jsgerber/temp/pythontempfiles/mapconfig.ini')
MAPS_DIR=config.get('MapConstants','MAPS_DIR')
input_tif_filename=config.get('MapConstants','input_tif_filename')
map_filename=config.get('MapConstants','map_filename')
cmap_string=config.get('MapConstants','cmap_string')
cbar_title=config.get('MapConstants','cbar_title')
cbar_units=config.get('MapConstants','cbar_units')
extend_cbar=config.get('MapConstants','extend_cbar')
data_min=config.getfloat('MapConstants','data_min')
data_max=config.getfloat('MapConstants','data_max')
### end code from prev version

# # section to turn cmap_string into cmap
# cmap_string can be something like 'Greens' or 
# cmap_string = ['#F2FAEB', '#DCF0C7', '#C5E6A2', '#AFDD7E', '#98D35A', '#82C936', '#6BA52C', '#538122', '#385617']
# in which case
# cmap_colors=cmap_string
# cmap = LinearSegmentedColormap.from_list('my_custom_cmap', cmap_colors)



## This worked, trying something more general
# stringlist=[];
# stringlist.append(cmap_string)
# cmap=colorstring_to_colormap.make_cmap(stringlist)
# 
# ## trying this
def parse_colormap_colors(config, section='MapConstants', key='cmap_string'):
    raw = config.get(section, key).strip()

    # If it contains commas, treat as list
    if ',' in raw:
        colors = [c.strip() for c in raw.split(',')]
    else:
        # Single entry → wrap in list
        colors = [raw]

    return colors

from colorstring_to_colormap import make_cmap

cmap_colors = parse_colormap_colors(config)
cmap = make_cmap(cmap_colors)

## end trying




## open raster, reproject to robinson, and clip to admin boundaries
map_da = mapping_utils.prep_global_raster_mapping(tif_path=input_tif_filename, rtype='continuous')

## usually plot the data_min to the 99th percentile value of data
#data_min, data_max, data_percile = raster_utils.get_summary_stats(map_da, 99)

print(matplotlib.get_backend())



## takes around 15 sec to run
print(data_max)
## map only
mapping_utils.plot_global_raster_maponly(
    fig_width=figsize_w,
    fig_height=figsize_h,
    data_array=map_da,
    arr_cmap=cmap,
    data_min=data_min,
    data_max=data_max,
    admin_boundaries=gadm_robinson,
    map_output_dir=MAPS_DIR,
    map_filename=map_filename   
)
print(matplotlib.get_backend())

## export legends
mapping_utils.export_alllegends_continuous_cbar(
    cmap=cmap,
    vmin=data_min, # 0 
    vmax=data_max, # 100
    extend_cbar=extend_cbar, # can also be 'max', 'min'
    cbar_title=cbar_title,
    legend_filename=map_filename,
    output_dir=MAPS_DIR,
    # uncomment if you'd like to customize min and maxes on colorbar more (e.g. to add '> 90' for example)
    #set_cbar_labels=True, 
    #cbar_min='0',
    #cbar_max=round(data_percile, 2)
)

import sys
print(sys.executable)
print(sys.version)