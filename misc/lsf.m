function lsf
% lsf list only directories
if isunix
unix(['ls -F | grep /']);
%unix(['ls -lF | grep /']);
end