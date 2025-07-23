function varargout=helperfunction(varargin)
% helper function to deal with capitalization issue
persistent madewarning
if isempty(madewarning)
    madewarning=1;
    disp(['calling ' lower(mfilename) ' (no caps)']);
end
[varargout{1:nargout}]=feval(lower(mfilename),varargin{:});



