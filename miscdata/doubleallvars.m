function DoubleAllVars
% DOUBLEALLVARS Turn all single valued variables to double
%
%
%   Syntax
%       DoubleAllVars  with no arguments will examine all variables in the
%       base workspace, and take those of class 'single' and make them
%       'double.'   It's useful when trying to use tools (e.g. graphics
%       tools) which require double precision inputs on a set of data that
%       is all single.  
%
%       This is a development tool: it is a bad idea to use this within any
%       function or script.


% JSG
% Institute on the Environment
% October, 2009

a=evalin('caller','whos');
for j=1:length(a);
    if isequal(a(j).class,'single')
        evalin('caller',[a(j).name '=double(' a(j).name ');']);
    end
end
