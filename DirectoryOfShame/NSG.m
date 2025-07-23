function varargout=NSG(varargin)
% helper function to deal with capitalization issue
disp(['called ' mfilename ' (note caps)']);
[varargout{1:nargout}]=feval(lower(mfilename),varargin{:});



