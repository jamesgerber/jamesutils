function varargout=tsa(varargin)
% "tsa" thirty second area, passthrough to get30secondgridcellareas

[varargout{1:nargout}]=feval('get30secondgridcellareas',varargin{:});