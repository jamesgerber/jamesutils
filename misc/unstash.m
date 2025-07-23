function unstash(varname);
% UNSTASH  retrieve copy of a variable to base workspace (see stash)
%

%  See also:   stash

x=getappdata(0,['stash' varname]);
assignin('caller',varname,x)



