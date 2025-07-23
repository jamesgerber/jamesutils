function lsft
% lsft list only directories, by timestamp (in reverse)
if isunix
unix(['ls -Ftr | grep /']);
%unix(['ls -lF | grep /']);
end