function AddCoastCallback(varargin);
% AddCoastCallBack - Zoom graph to maximum value.

if nargin==0
    help(mfilename);
    return
end

InputFlag=varargin{1};

switch(InputFlag)
    case 'Initialize'
       
        uicontrol('String','Add Coastline','Callback', ...
            'AddCoastCallback(''AddCoast'')','position',NextButtonCoords);
        
    case 'AddCoast'
        % find maximum, zoom in       
        
        AddStates(gcbf);
    otherwise
        error('syntax error in AddCoastCallBack.m')
        
end
end
