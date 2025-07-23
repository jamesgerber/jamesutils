function varargout=DownSurf(Long,Lat,Data,Units,TitleStr);
% THINSurf - undersample data to keep plot memory below 200MB
%
% SYNTAX
%     DownSurf(Long,Lat,Data) will make a surface plot with undersampled
%     data.
%
%     DownSurf(Long,Lat,Data,Units,TitleStr) will put 'Units','Title' on
%     the plot
%
%     DownSurf(Data);  will assume global coverage of data and construct
%     Long, Lat
%
%     DownSurf(DS);  where DS is a matlab structure will look for fields
%     Long, Lat, Data, Title, Units
%
%
%    See Also:  ThinSurf  IoneSurf
%
%
% EXAMPLE
%   DownSurf(testdata);
%
%    This code differs from ThinSurf by only one line

if nargin==0
    help(mfilename);
    return
end

InputVariableName=inputname(nargin);  %Variable name from calling workspace.

switch nargin
    case 1
        % only one argument in.  Either user is simply passing in a big array and
        % expecting ThinSurf to infer the Lat and Long, or that one argument is a
        % structure that has the data in it.
        
        %  note that whichever option is true, the variable is called Long.
        %  Rename to make the code more readable.
        Data=Long;
        clear Long
        if isstruct(Data)
            % it's a structure.  Call a utility to unpack ...
            [Long,Lat,Data,Units,DefaultTitleStr,NoDataStructure]=ExtractDataFromStructure(Data);
            % now check to make sure that we got a title.  If we didn't use the
            % input variable name.
            if nargin < 5
                % User did not supply a title.  We need to find in.  Best is
                % whatever came from ExtractDataFromStructure, but make sure it
                % isn't empty first
                if ~isempty(DefaultTitleStr)
                    TitleStr=DefaultTitleStr;
                else
                    TitleStr=InputVariableName
                end
            else
                % Comment to make code readable:
                % We are here bec user did supply TitleStr.  Nothing to do.
            end
            
        else
            % it's a matrix.  Call a utility to figure out Long, Lat
            
            [Long,Lat]=InferLongLat(Data);
            TitleStr=InputVariableName;
            Units='';
        end
    case 3
        Units='';
        TitleStr=InputVariableName;
    case 4
        TitleStr='';
end

if length(Long)<=2160
    disp([' data is 10 min or coarser.  not downsampling.']);
    RedLong=Long;
    RedLat=Lat;
    RedData=Data;
else
    RedLong=Long(1:2:end);
    RedLat=Lat(1:2:end);
    RedData=Data(1:2:end,1:2:end);
end

h=IoneSurf(RedLong,RedLat,RedData,Units,TitleStr);

if nargout==1
    varargout{1}=h;
end
