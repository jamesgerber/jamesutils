function [OS]=getcropcharacteristics(cropname);
% getcropcharacteristics - get crop characteristics from cropinfo.csv file
%
% SYNTAX
% getcropcharacteristics(cropname) - return characteristic struct for the
% given cropname.
%
% EXAMPLE
%  CC=getcropcharacteristics('wheat')
%
%  CC=getcropcharacteristics;
%
%  Jan, 2015 - updated to include calorie information

if nargin==0 & nargout==0;help(mfilename);return;end

% get crop data
persistent C D
if isempty(C)
    C=ReadGenericCSV([iddstring '/misc/cropdata.csv']);
    D=ReadGenericCSV([iddstring '/misc/crop_kcals.csv']);
end

if ~isequal(C.CROPNAME,D.CROPNAME)
    error([' this code written with bad assumptions about data files'])
end

C.num=D.num;
C.kcals_per_ton_fao=D.kcals_per_ton_fao;
C.kcals_per_ton_tilman=D.kcals_per_ton_tilman;

if nargin==0
    OS=C;
    return
end

idx=strmatch(char(cropname),C.CROPNAME,'exact');

if numel(idx)~=1
    error([' don''t have a unique crop match'])
end


a=fieldnames(C);

OS=[];
for j=1:length(a);
    longfield=getfield(C,a{j});
    OS=setfield(OS,a{j}, longfield(idx));
end


% CROPNAME: {175x1 cell}
% GROUP: {175x1 cell}
% Legume: {175x1 cell}
% C3C4: {175x1 cell}
% Ann_Per: {175x1 cell}
% Form: {175x1 cell}
% Harvest_Index: [175x1 double]
% Dry_Fraction: [175x1 double]
% Aboveground_Fraction: [175x1 double]
% N_Perc_Dry_Harv: {175x1 cell}
% P_Perc_Dry_Harv: {175x1 cell}
% K_Perc_Dry_Harv: {175x1 cell}
% Nfix_low: {175x1 cell}
% Nfix_med: {175x1 cell}
% Nfix_high: {175x1 cell}
% GDDBase: {175x1 cell}
% FAOName: {175x1 cell}
% MonfredaName: {175x1 cell}
% DisplayName: {175x1 cell}
% FAOItemNumber: {175x1 cell}
% ConstructedCrop: [175x1 double]