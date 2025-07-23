function var=var2str(var)
% VAR2STR - calls *2str, where * is the appropriate variable type.
%
% SYNTAX
% str=var2str(var) - str is set to string representation of var.
%
% EXAMPLE
% arraystring=var2str([1 2 3])
% numstring=var2str(4);
% stringstring=var2str('5');
if (ischar(var))
    var=['' var ''];
end

if (isvector(var)||ismatrix(var))
    var=mat2str(var);
end

if (isnumeric(var))
    var=num2str(var);
end