function lsfr
% lsfr list only directories, with -r flag (latest at bottom)
%
% See also: lsf
if isunix
    unix(['ls -Ftr | grep /']);
end