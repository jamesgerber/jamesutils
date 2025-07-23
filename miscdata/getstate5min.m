function f=getstate5min(row,col)
% GETSTATE5MIN - get state at given indices
%
% SYNTAX
% f=getstate5min(r,c) - set f to the name of the state at row-col, based on
% a 5min resolution map of the world
load 'countrydata.mat';
f=a{row,col}