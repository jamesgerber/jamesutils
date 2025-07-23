function [colormap,reversecolormap]=ReadCmapfunction(FileName);
% READTIFFCMAP  Read in function-defined colormap
%
%  SYNTAX
%   [colormap,reversecolormap]=ReadTiffCmap('kelp.m');
%  
%   See finemap for a list of 'standard' colorbars
%
%   See also finemap

if nargin==0 & nargout==0
  help(mfilename);
  return
end

if nargin==0
  [filename, pathname] = uigetfile('*.tiff');
  FileName=fullfile(pathname,filename);
end


a=imread(FileName);

N=size(a,2);

colormap=double(squeeze(a(1,1:N,[1 2 3])))/256;

%% determine if this is a 16 element color bar

if length( unique(colormap,'rows'))==16
    colormap=double(squeeze(a(1,1:16:256,[1 2 3])))/256;
else
    colormap=double(squeeze(a(1,1:N,[1 2 3])))/256;
end
reversecolormap=colormap(end:-1:1,:);


  

