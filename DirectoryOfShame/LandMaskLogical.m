function LogicalVector=LandMaskLogical(varargin);
% LANDMASKLOGICAL -  logical array of standard landmask
%
%  Syntax
%
%      LogicalMatrix=LandMaskLogical - returns the 5 minute landmask
%
%      LogicalMatrix=LandMaskLogical(DataTemplate) -returns a landmask of
%        the size of DataTemplate (if DataTemplate is 5 or 10 mins)
disp(['warning ... called ' mfilename ' with capital letters.']);
LogicalVector=landmasklogical(varargin{1:end});