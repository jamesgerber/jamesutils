function [jj]=findpeaks_jg(y,threshold);
% FINDPEAKS_JG - find maxima 
%
%   Syntax  ii=findpeaks_jg(Y,THRESH) will return indices of all maxima in Y
%   which are above THRESH
%
%
%   EXAMPLE
%   A=rand(1,20)
%   ii=findpeaks_jg(A,.5)

if nargin==0;help(mfilename);return;end;

if nargin==1
   threshold=-Inf;
end

ii=2:(length(y)-1);
j=find(y(ii)>=y(ii+1) & y(ii)>y(ii-1));

jj=j+1;

jj=jj(find(y(jj)>=threshold));


