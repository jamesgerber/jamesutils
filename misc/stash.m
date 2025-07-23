function varargout=stash(varname);
% STASH  store a copy of a variable in appdata (safe from clear)
%
%  See also:   unstash
if nargout==0
    try
        x=evalin('caller',varname);
        setappdata(0,['stash' varname],x);
    catch
        warning([ varname ' doesn''t appear to exist '])
    end
    
else
   varargout{1}=getappdata(0,['stash' varname]);
end


