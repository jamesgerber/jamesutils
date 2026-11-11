"""
Colormap utils for MATLAB:

Usage:
    pyrun("from colormap_utils import fetch_cmap, create_color_axis_range")
    cmap = pyrun("cmap_hex, cmap_rgb = fetch_cmap('cmap_name')", ["cmap_hex", "cmap_rgb]) 

    data_range = pyrun("bound_list = create_color_axis_range(data, 'type')", "bound_list")

Notes:
You need to get the import right in the pyrun.
The simplest way to get this to work is modifying your startup.m so that jamesutils is added to the python path making it easy to import.

setenv('PYTHONPATH', ['{PYTHON_MATLAB_PATH}', pathsep, getenv('PYTHONPATH')]);



For the string inputs make sure if you aren't directly passing a variable it is enclosed in quotes for example 'viridis' not viridis, otherwise python will complain that viridis is not a variable. 

Here is a mini-demo of how to use it. 
%% colormap_utils demo

pyrun("import importlib, colormap_utils")
% Fetch a built-in matplotlib colormap: 100 colors as hex strings and rgb triplets
[cmap_hex, cmap_rgb] = pyrun("from colormap_utils import fetch_cmap; cmap_hex, cmap_rgb = fetch_cmap('viridis')", ["cmap_hex", "cmap_rgb"])
hex_cell = string(cell(cmap_hex));   % 1x256 cellstr, e.g. hex_cell(1) = '#440154'
rgb_mat = double(cmap_rgb/255);          % 256x3 matrix, rows are [r g b] 0-1

% Fetch a custom colormap (from cmaps.json). Add '_r' to get it reversed:
cmap = string(cell(pyrun("from colormap_utils import fetch_cmap; cmap_hex, _ = fetch_cmap('cb_brbg')", "cmap_hex")));
cmap_rev = string(cell(pyrun("from colormap_utils import fetch_cmap; cmap_hex, _ = fetch_cmap('cb_brbg_r')", "cmap_hex")));

% Get color axis limits for a dataset: pass the data and how to bound each side
bounds = pyrun("from colormap_utils import create_color_axis_range; bound_list = create_color_axis_range(data, '5%', '95%')", "bound_list", data = randn(1000, 1));
lims = double(bounds)   % 1x2: [lower_percentile, upper_percentile]

To add new matlab colormaps theres a provided command line utility simply run:
python path/to/colormap_utils.py add_m_cmap path/to/somesortofcolorbar.m
"""

import json
import os
from pathlib import Path
from typing import Iterable
from PIL import Image
import re

from matplotlib.pyplot import colormaps
from matplotlib.colors import to_hex
import numpy as np

cmap_dict: dict[str, list[tuple[int, int, int]]] = {}

rgb_color = tuple[int,int,int]
def fetch_cmap(map_name: str) -> tuple[list[str], np.ndarray]:
    """
    Fetch a cmap from one of two sources. Either the matplotlib cmap directory. 
    Or the local cmaps.json file that contains many custom cmaps.

    For the mpl path, it simply takes the map_name and maps it to 0-100 and 
    returns it in both hex and rgb-int format
    
    For the local path, it does the same thing but the length is not fixed.
    TODO Add Linear Interpolation (Up to Jamie)


    Returns:
        A pair of lists, the first being the hex version of the colormap and the second being the rgb int version
    """
    mpl_map = colormaps.get(map_name, None)
    if mpl_map:
        colors_01 = list(mpl_map(np.linspace(0, 1, 256))) 
        hexes = [to_hex(c) for c in colors_01]
        rgbs = [(int(round(r * 255)), int(round(g * 255)), int(round(b * 255)))
                for r, g, b, *_ in colors_01]
        return (hexes, np.array(rgbs))

    with open(Path(__file__).parent.joinpath("cmaps.json"), "r") as cmap_json:
        jamie_maps = json.load(cmap_json)

    reversed_map = map_name.endswith("_r")
    base_name = map_name.removesuffix("_r")

    base_map = jamie_maps.get(base_name)
    if not base_map:
        raise ValueError(f"No Jamie or MPL cmap found with name {base_name}")

    base_map = list(base_map)
    if reversed_map:
        base_map.reverse()

    zero_one_scale = [(r / 255, g / 255, b / 255) for r, g, b in base_map]
    return (list(map(to_hex, zero_one_scale)), np.array(base_map))

def create_color_axis_range(data: Iterable, lower_bound:str="min", upper_bound: str="max") -> np.ndarray:
    """
    Calculate a range of values from the data, defaults to [min, max] returns as a numpy array since they work better with MATLAB.

    Args:
        data: Any iterable data, should work for a matrix, an array, an array of arrays. 
        lower_bound: String defaults to min, also valid 'XXX%' which will parse as the XXXth percentile
        upper_bound: String defaults to max, also valid 'XXX%' which will parse as the XXXth percentile

    Returns:
        [lower, upper] where these are the calculated bounds form the data according to the strings
    """
    flat_data = _flatten_data(data)
    return np.array([_compute_statistic(flat_data, lower_bound), _compute_statistic(flat_data, upper_bound)])


def parse_colormap_m(path: str) -> list[rgb_color]:
    """
    Parse a MATLAB .m colormap file.
    
    MATLAB .m files are a bit goofy, they have functions at the top level as well as ocasional comments
    so regexp was used to find the correct lines being the cmap = [*]. The points were all on [0,1] scale so they
    have been scaled to int scale. 

    Args:
        path: the path to the .m file for example jfblue.m
    Returns:
        A list of rgb tuples in 0-255 scale.

    """
    text = open(path).read()
    # strip % comments
    text = "\n".join(re.sub(r"%.*", "", line) for line in text.splitlines())

    m = re.search(r"cmap\s*=\s*\[(.*?)\]", text, re.S | re.I)
    if m is None:
        # fall back: take everything between the first [ and last ]
        i, j = text.find("["), text.rfind("]")
        if i == -1 or j == -1:
            return []
        body = text[i + 1 : j]
    else:
        body = m.group(1)

    # Strip a MATLAB trailing division like ]/255; so the 255 isn't parsed as a color value
    body = re.sub(r"\]\s*/\s*255\s*;?\s*$", "", body.strip())

    floats = [float(x) for x in re.findall(r"[-+]?\d*\.\d+|[-+]?\d+", body)]
    if len(floats) % 3:
        raise ValueError(f"{path}: {len(floats)} values, not divisible by 3")

    # Files can have colors on the [0, 1] float scale or the [0, 255] int scale, detect which
    if max(floats) <= 1.0:
        return [
            tuple(int(round(255 * v)) for v in floats[k:k + 3])
            for k in range(0, len(floats), 3)
        ]
    return [
        tuple(int(round(v)) for v in floats[k:k + 3])
        for k in range(0, len(floats), 3)
    ]


def _write_cmaps_json(cmap_dict: dict, out_path: str) -> None:
    """
    Write a dict of colormaps to `out_path/cmaps.json` in the canonical format:
    one line per colormap, keys sorted lexicographically.

    Args:
        cmap_dict: Dict mapping colormap names to lists of [r, g, b] int rows
        out_path: Path to the directory where to put the cmaps.json file
    """
    with open(Path(out_path).joinpath("cmaps.json"), "w") as f:
        f.write("{\n")
        items = list(cmap_dict.items())
        items.sort(key=lambda x: x[0])
        for i, (name, cmap) in enumerate(items):
            rows = ", ".join(json.dumps(row, separators=(", ", ": ")) for row in cmap)
            comma = "," if i < len(items) - 1 else ""
            f.write(f'  "{name}": [{rows}]{comma}\n')
        f.write("}\n")


def clean_cmaps_json(path: str = "") -> None:
    """
    Clean up cmaps.json: re-sorts the keys the same way as the original ingestion
    and rewrites the file in the canonical one-line-per-cmap format.

    Args:
        path: Path to the cmaps.json file to clean up, defaults to the one next to this module
    Returns:
        None, but the file at `path` is overwritten with the cleaned version.
    """
    path = path or Path(__file__).parent.joinpath("cmaps.json")
    with open(path, "r") as f:
        cmap_dict = json.load(f)
    _write_cmaps_json(cmap_dict, str(Path(path).parent))
    print(f"Cleaned {len(cmap_dict)} colormaps in {path}")


def add_m_cmap(path: str, name: str = "", out_path: str = "") -> list[rgb_color]:
    """
    Append a single colormap from a MATLAB .m file into cmaps.json.

    Parses the .m file, adds it under the given name (or the filename without
    extension if no name is given), then rewrites cmaps.json sorted and formatted
    the same way as the original ingestion.

    Args:
        path: Path to the MATLAB .m colormap file for example jfblue.m
        name: Optional name to store the colormap under. If not given, uses the file
            name up to (but not including) the first period.
        out_path: Path to the directory containing cmaps.json, defaults to the directory
            this module lives in.
    Returns:
        The parsed list of rgb tuples in 0-255 scale that was added.
    """
    formatted_cmap = parse_colormap_m(path)
    if not formatted_cmap:
        raise ValueError(f"Could not parse a colormap from {path}")

    if not name:
        name = Path(path).name.split(".")[0]

    json_dir = out_path or Path(__file__).parent
    json_path = Path(json_dir).joinpath("cmaps.json")
    with open(json_path, "r") as f:
        cmap_dict = json.load(f)
    cmap_dict[name] = formatted_cmap
    _write_cmaps_json(cmap_dict, str(json_dir))
    print(f"Added '{name}' ({len(formatted_cmap)} colors) to {json_path}")
    return formatted_cmap


def process_cmap_dir(dir_path: str, out_path: str = "") -> None:
    """
    Process the ione colormaps directory into one json file which is put into `out_path/cmaps.json`

    Essentially it takes each tiff and each .m colormap, converts them to an rgb [0,255] scale array
    and writes a large dict that has keys equal to the names with the values being those arrays.


    NOTE:
    * This should not need to be ran as the cmaps.json is in this directory in a slightly cleaned up form.
    * Colormaps computed from images often will contain buffers which are effectively errors and need to be manually cleaned up
    * Instead use the above add_m_cmap to add matlab cmaps

    Args:
        dir_path: String directory path to the colormaps directory
        out_path: Path to the directory where to put the cmaps.json file
    """
    for file in os.listdir(dir_path):

        if file.endswith(".tiff"):
            array_data = np.array(Image.open(f"colormaps/{file}"))[0] # Only first row since tif is identical data all the way down
            formatted_cmap = [(int(data[0]), int(data[1]), int(data[2])) for data in array_data] # We don't need the alpha data
        elif file.endswith(".m"):
            # Call octave to convert
            formatted_cmap = parse_colormap_m(f"colormaps/{file}")
            if formatted_cmap is None:
                continue
        else:
            continue
        # Colormap name assumed before period
        cmap_dict[file.split(".")[0]] = formatted_cmap

    _write_cmaps_json(cmap_dict, out_path)


def main() -> None:
    """
    Command line interface for the cmaps.json utilities:

    python colormap_utils.py clean [--path STR]
    python colormap_utils.py add_m_cmap PATH [--name STR] [--out-path STR]
    """
    import argparse

    parser = argparse.ArgumentParser(description="Utilities for cmaps.json")
    subparsers = parser.add_subparsers(dest="command", required=True)

    clean_parser = subparsers.add_parser("clean", help="Re-sort and reformat cmaps.json")
    clean_parser.add_argument("--path", default="", help="Path to cmaps.json, defaults to the one next to this module")

    add_parser = subparsers.add_parser("add_m_cmap", help="Append a colormap from a MATLAB .m file to cmaps.json")
    add_parser.add_argument("path", help="Path to the MATLAB .m colormap file")
    add_parser.add_argument("--name", default="", help="Name to store the colormap under, defaults to the file name")
    add_parser.add_argument("--out-path", default="", help="Path to the directory containing cmaps.json, defaults to the directory this module lives in")

    args = parser.parse_args()

    if args.command == "clean":
        clean_cmaps_json(args.path)
    elif args.command == "add_m_cmap":
        add_m_cmap(args.path, args.name, args.out_path)



def _compute_statistic(data: Iterable, statistic_string: str) -> float:
    """
    Helper for the bounds, computes the statistic_string for the data. 
    
    Args:
        data: Iterable with numeric data (array, matrix, etc)
        statistic_string: One of "min", "max", or "XXX%" to compute the min, max or XXX'th percentile, more to come.
    
    Returns: 
        The computed statistic
    """
    if statistic_string == "min":
        return min(data)
    elif statistic_string == "max":
        return max(data)
    elif '%' in statistic_string:
        percentile_regexp = re.compile(r'\d{1,3}')
        search = percentile_regexp.search(statistic_string)
        if search is None:
            raise ValueError("Percentile must have 1-3 digits before the % sign")

        return np.percentile(data, float(search.group()))

    else:
        raise ValueError(f"Currently only min/max and xxx% are supported, you sent {statistic_string}")

def _flatten_data(data: Iterable) -> list:
    """
    Flattens an iterable and sorts it, works recursively

    Args: 
        data: Any iterable can be arbitrarily nested (matrix, list, etc)
    Returns:
        List of the elements in the unpacked data Iterable
    """
    final_data = []
    for element in data:
        if isinstance(element, Iterable):
            final_data = final_data + _flatten_data(element) # List concatenation
        else:
            final_data.append(element)
    final_data.sort()
    return final_data


if __name__ == "__main__":
    main()