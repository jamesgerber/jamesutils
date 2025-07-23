function varargout= mdnplot(varargin);
% MDNPLOT - plot data with matlab date numbers, provide useful UI
%
%
%  example
%
%% Get traffic count data
% load count.dat
% % Create arrays for an arbitrary date, here April 18, 1995
% n = length(count);
% year = 1990 * ones(1,n);
% month = 4 * ones(1,n); 
% day = 18 * ones(1,n);
% % Create arrays for each of 24 hours;
% hour = 1:n;
% minutes = zeros(1,n);
% % Get the datenums for the data (only hours change)
% mdn = datenum(year,month,day,hour,minutes,minutes);
% % Plot the traffic data against datenums
% figure
% mdnplot(mdn,count)


switch nargout
    case 0
        
        plot(varargin{1:end});
        
    otherwise
        varargout{1:nargout}=plot(varargin{1:end});
end


uicontrol('String','refreshdate','Callback', ...
            'datetick(''keeplimits'')','position',[5.0000   12.5000  120.0000   25.0000]);
zoom on