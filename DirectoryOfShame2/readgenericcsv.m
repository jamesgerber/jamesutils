function varargout=functioname(varargin)
% Generic function with case-insensitivity
DS=ReadGenericCSV(varargin{1:end});
varargout{1}=DS;