function [jj]=FindPeaks(y,threshold);
% FINDPEAKS - find maxima.  Danger! A real matlab function named this!
%
%   Syntax  ii=FindPeaks(Y,THRESH) will return indices of all maxima in Y
%   which are above THRESH

if nargin==0;help(mfilename);return;end;

if nargin==1
   threshold=-Inf;
end

ii=2:(length(y)-1);
j=find(y(ii)>=y(ii+1) & y(ii)>y(ii-1));

jj=j+1;

jj=jj(find(y(jj)>=threshold));


