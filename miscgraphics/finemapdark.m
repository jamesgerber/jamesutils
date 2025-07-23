function varargout=finemapdark(cmap,lowercolor,uppercolor)
% FINEMAP - interpolate the colormap finely and put blue on the bottom
%
%  Syntax
%
%
%    finemap(colormap,lowercolor,uppercolor);
%
%    colormap may be a colormap, or a text string, or '' for the default
%
%    lowercolor may be '' (empty) or 'aqua' or 'robin'
%
%    uppercolor may be '' 'white' 'black' 'robin'
%
%
%    if first three characters of colormap are 'rev', then the colormap
%    will be reversed:  e.g. finemap('revjfcayenne') will use a reversed
%    version of the 'jfcayenne' colormap.
%
%   Other colormaps include
%  'DesertToGreen2'
%
%  This code will look in ../Library/IonE/data/misc/Colormaps
%    Also some colormpas that Jon wrote:
%    jfblue-red
%    jfbrown-green.tiff
%    jfgreen-brown
%    jfcayenne
%    jfclover
%    jfmaroon
%    jfmocha-ocean
%    jfmocha
%    jfmoss
%    jfocean
%    jfplum
%    jftangerine
%    colormap may be one of the built-in matlab colormaps (see below)
%
%  
%    hsv        - Hue-saturation-value color map.
%    hot        - Black-red-yellow-white color map.
%    gray       - Linear gray-scale color map.
%    bone       - Gray-scale with tinge of blue color map.
%    copper     - Linear copper-tone color map.
%    pink       - Pastel shades of pink color map.
%    white      - All white color map.
%    flag       - Alternating red, white, blue, and black color map.
%    lines      - Color map with the line colors.
%    colorcube  - Enhanced color-cube color map.
%    vga        - Windows colormap for 16 colors.
%    jet        - Variant of HSV.
%    prism      - Prism color map.
%    cool       - Shades of cyan and magenta color map.
%    autumn     - Shades of red and yellow color map.
%    spring     - Shades of magenta and yellow color map.
%    winter     - Shades of blue and green color map.
%    summer     - Shades of green and yellow color map.
%
%
%  EXAMPLE
%   finemapdark(jet,'aqua','black');

if nargin==1 & isstr(cmap) & isequal(lower(cmap),'version')

    [RevNo,RevString,LCRevNo,LCRevString,AllInfo]=GetSVNInfo;
        varargout{1}=AllInfo;
        return
end


if nargin==0 | isempty(cmap)
    cmap='jfgreen-brown';
end

if nargin<2
    lowercolor='robin';
end

if nargin~=3
    uppercolor='default';
end

ReverseMapFlag=0;
if ~isnumeric(cmap)
    if strmatch(cmap(1:3),'rev');
        cmap=cmap(4:end);
        ReverseMapFlag=1;
    end
    cmap=StringToMap(cmap);
    if ReverseMapFlag==1
        cmap=cmap(end:-1:1,:);
    end
end

switch lowercolor
    case {'','default'}
        lc=[];
    case 'aqua'
        lc=[    0.0352    0.4258    0.5195];
    case 'blue'
        lc=[127/255 1 212/255];
    case 'black'
        lc=[0 0 0];
            case 'white'
        lc=[1 1 1];
    case 'robin'
        lc=[ 0.5977    0.7969    0.9961];
    otherwise
        error(['don''t know this lowercolor bound'])
end

switch uppercolor
    case {'','default'}
        uc=[];
            case 'white'
        uc=[1 1 1];
    case 'black'
        uc=[0 0 0];
    case 'robin'
        uc=[        0.5977    0.7969    0.9961];
    otherwise
        error
        
end

map=cmap;

InterpStep=length(map)/2048; % somewhat arbitrary ...

x=1:length(map);
xx=1:InterpStep:x(end);

for j=1:3;
  mapp(:,j)=interp1(x,map(:,j),xx);
end

if ~isempty(lc)
    mapp(2:end+1,:)=mapp;
    mapp(1,:)=lc;
end

if ~isempty(uc)
    mapp(end,:)=uc;
end



if nargout==0
    colormap(mapp)
else
    varargout{1}=mapp;
end

%%%%%%%%%%%%%%%
% StringToMap %
%%%%%%%%%%%%%%%
function cmap=StringToMap(str);

try
    % first try matlab's built in functions (or any functions on the path)
    cmap=colormap(str);
catch
                SystemGlobals

        try

            cmap=ReadTiffCmap([IoneDataDir '/misc/colormaps/' str '.tiff']);
        catch 
        
            switch lower(str)
%                case {'DesertToGreen2','deserttogreen2'}
%            SystemGlobals
%            cmap=ReadTiffCmap([IoneDataDir '/misc/colormaps/DesertToGreen2.tiff']);
%                case {'GreenToDesert2','greentodesert2'}
%            SystemGlobals
%            [dum,cmap]=ReadTiffCmap([IoneDataDir '/misc/colormaps/DesertToGreen2.tiff']);
                case {'jfclover'}
                    SystemGlobals
                    cmap=ReadTiffCmap([IoneDataDir '/misc/colormaps/jfclover.tiff']);
              case {'jfgreen-brown'}
                    SystemGlobals
                    [dum,cmap]=ReadTiffCmap([IoneDataDir '/misc/colormaps/jfbrown-green.tiff']);
                  
        otherwise
            error([' don''t know this colormap '])
            end
    end
end
