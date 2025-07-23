function AddStatesCallBack(varargin);

if nargin==0
    help(mfilename);
    return
end

InputFlag=varargin{1};

switch(InputFlag)
    case 'Initialize'
       
        uicontrol('String','Add States','Callback', ...
            'AddStatesCallBack(''AddCoast'')','position',NextButtonCoords);
        
    case 'AddCoast'
        % find maximum, zoom in       
        
        AddStates(gcbf);
    otherwise
        error('syntax error in AddStatesCallBack.m')
        
end
end
