function output=Amazonia;
% AMAZONIA -  logical array of amazonia
%
%  Syntax
%
%      LogicalMatrix=Amazonia - returns
%  
%  Example
%
%     x=Amazonia;
%     whos x
%     fastsurf(x);
%     
%   Example 2 To create logical after ^^
%     
%     y = logical(x);

load([iddstring 'misc/watersheds/globe1.mat'])

LogicalMatrix = zeros(4320,2160);

LogicalMatrix(Q == 2160) = 1;


output = LogicalMatrix;

end
