function varargout=finemap(cmap,lowercolor,uppercolor)
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
%   A hack is colormap 'randomX' where X is log10 of the number of digits
%   to use in the colormap.  if X larger than 4, colorbar is gray.
%
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
%
%  EXAMPLE
%   finemap(jet,'aqua','black');

if nargin==0
    disp(['Here are existing colormaps.  Built-in ones OK also.'])
    ls([iddstring '/misc/colormaps/*.tiff']);
    ls([iddstring '/misc/colormaps/*.m']);
    return
end


if nargin==1 & isstr(cmap) & isequal(lower(cmap),'version')
    
    [RevNo,RevString,LCRevNo,LCRevString,AllInfo]=GetSVNInfo;
    varargout{1}=AllInfo;
    return
end


if nargin==0 | isempty(cmap)
    cmap='jfgreen-brown';
end

if nargin<2
    %    lowercolor='robin';
    lowercolor=callpersonalpreferences('oceancolor');
    
end

if nargin~=3
    %    uppercolor='default';
    uppercolor=callpersonalpreferences('nodatacolor');;
end


Nsteps=2048;

ReverseMapFlag=0;
if ~isnumeric(cmap)
    if strmatch(cmap(1:3),'rev');
        cmap=cmap(4:end);
        ReverseMapFlag=1;
    end
    [cmap,Nsteps]=StringToMap(cmap);
    if ReverseMapFlag==1
        cmap=cmap(end:-1:1,:);
    end
end
if ~ischar(lowercolor)
    lc=lowercolor;
else
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
        case 'bluemarble'
            lc=[0.0588    0.1176    0.5490];
        case 'emblue'
            lc=[0.451    0.616    0.878];
        case {'gray'}
            lc=[.8 .8 .8];
        case 'joanneblue'
            lc = [0.835294118 0.894117647 0.960784314];
            %case {'joannegray','joannegrey'}
            %    lc =[.74 .74 .74];
        case {'lightskyblue','lightskyblue4'}
            lc=[0.3765 0.4824 0.5451];
        case {'lsb1','lightsteelblue1'}
            lc=[202 225 255]/256;
        otherwise
            error(['don''t know this lowercolor bound: ' lowercolor])
    end
end
if ~ischar(uppercolor)
    uc=uppercolor;
else
    switch uppercolor
        case {'','default'}
            uc=[];
        case 'white'
            uc=[1 1 1];
        case 'black'
            uc=[0 0 0];
        case {'gray'}
            uc=[.8 .8 .8];
        case 'robin'
            uc=[        0.5977    0.7969    0.9961];
        case 'bluemarble'
            uc=[0.0588    0.1176    0.5490];
        case {'joannegray','joannegrey'}
            uc =[.74 .74 .74];
        case 'beige'
            uc=[245 245 220]/256;
        otherwise
            error(['don''t know this uppercolor bound: ' uppercolor]);
            
    end
end

map=cmap;

%InterpStep=length(map)/Nsteps; % somewhat arbitrary ...
InterpStep=size(map,1)/Nsteps; % somewhat arbitrary ...

%x=1:length(map);
x=1:size(map,1);
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
function [cmap,Nsteps]=StringToMap(str);


Nsteps=2048;

try
    cmap=ReadTiffCmap([iddstring '/misc/colormaps/' str '.tiff']);
    % first try matlab's built in functions (or any functions on the path)
    
catch
    try
        switch str
            
            case {'random','random1','random2','random3','random4','random5',...
                    'random6','random7','random8','random9'}
                
                if isequal(str,'random')
                    str='random3' % default
                end
                
                Ncmap=10^(str2num(str(end)));
                
                cmap=rand(Ncmap,3);
                Nsteps=Ncmap;
                
                
            otherwise
                
                
                
                
                % now it is probably something like 'jet'
                % need to get the colormap without having matlab change it around.
                % so, get the current one, open a figure, let that get screwed up,
                % erase the figure, reset the current colormap
                
                numfigs=length(allchild(0));
                addpath([iddstring 'misc/colormaps'],'-end')
                
                if numfigs==0
                    % no figures exist.  so need to make a figure to
                    tempfig=figure;
                    cmap=colormap(str);
                    delete(tempfig);
                    
                    
                    
                else
                    tempmap=colormap;
                    tempfig=figure;
                    cmap=colormap(str);
                    delete(tempfig);
                    colormap(tempmap);
                    
                end
        end
        
        
        
        
        
        
    catch
        
        % maybe it's an m-file
       try
           %tempfig=figure;
           cmap=eval(str);
           close
           %delete(tempfig);
       catch
        error([' don''t know this colormap: ' str])
       end
    end
end

