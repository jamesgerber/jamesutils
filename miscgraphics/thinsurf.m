function varargout=ThinSurf(Long,Lat,Data,Units,TitleStr);
% THINSurf - Surface plot with reduced dataset retaining maxima
%
% SYNTAX
%     ThinSurf(Long,Lat,Data) will make a surface plot with resampled
%     data such that local maxima and minima are retained
%
%     ThinSurf(Long,Lat,Data,Units,TitleStr) will put 'Units','Title' on
%     the plot
%
%     ThinSurf(Data);  will assume global coverage of data and construct
%     Long, Lat
%
%     ThinSurf(DS);  where DS is a matlab structure will look for fields
%     Long, Lat, Data, Title, Units
%
% EXAMPLE
%  ThinSurf(testdata(4320,2160,1));
%
%    See Also:  DownMap DownSurf  IoneSurf

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
            if min(size(Data))==1
                % This is a vector.  That's not good.  Either user messed up or
                % user is only sending us the values corresponding to the
                % DataMask
                DML=DataMaskLogical;
                DMI=find(DML);
                switch(length(Data))
                    case length(DMI)
                        %user has only sent in data corresponding to datamask
                        DML=DML*0;  %now use DML to construct a matrix for DATA
                        DML(DMI)=Data; %Data still a vector, assign it into DML
                        Data=DML;  %no Data is properly embedded in a matrix
                    case numel(DML)
                        % user has passed in the entire globe as a vector.
                        DML=DML*0;  %Use this matrix
                        DML(DMI)=Data(DMI);
                        Data=DML;
                    otherwise
                        
                        error(['Don''t know what to do with a vector of this length'])
                end
            end
            
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



if length(Long)<=2160 | length(Lat) <=1080
    disp([' data is 10 min or coarser.  not downsampling.']);
    RedLong=Long;
    RedLat=Lat;
    RedData=Data;
else
    [RedLong,RedLat,RedData]=DownMap(Long,Lat,Data);
end

h=IonESurf(RedLong,RedLat,RedData,Units,TitleStr);

if nargout==1
    varargout{1}=h;
end
