function [WithExtension,WithoutExtension]=FixExtension(name,ext)
% FIXEXTENSION - regularize a filename
%
% Syntax:
%
%      [WithExtension,WithoutExtension]=FixExtension(name,ext);
%  
%  Example
%
%   fixextension('maize_5min','nc')
%   fixextension('maize_5min.nc','nc')
%   fixextension('maize_5min','.nc')

if nargin <2
    help(mfilename)
    return
end

%%% changes the name and extension into character arrays
name = char(name);
ext = char(ext);

%% remove '.' from extension

if isequal(ext(1),'.')
    ext=ext(2:end);
end

%%
N=length(ext);
M=length(name);

if isequal(lower(name(M-(N-1):M)),lower(ext))
    WithExtension=name;
    WithoutExtension=name(1: (M-N-1));
else
    WithExtension=[name '.' ext];
    WithoutExtension=name;
end



