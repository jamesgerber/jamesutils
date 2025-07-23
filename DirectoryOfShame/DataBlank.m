function varargout=callwithoutcaps(varargin);
% function to work around caps-sensitive matlab version 
persistent madewarning
if isempty(madewarning)
    madewarning=1;
    disp(['calling ' lower(mfilename) ' (no caps)']);
end

[varargout{1:nargout}]=feval(lower(mfilename),varargin{:});