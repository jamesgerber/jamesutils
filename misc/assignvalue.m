function assignvalue(name,value)
% ASSIGNVALUE - place a specified variable name/value pair
%
% SYNTAX
% assignvalue(name,value) - set a variable called name to value
%
% EXAMPLE
% assignvalue('newvariablename','newvariablevalue');
assignin('caller',name,value)
