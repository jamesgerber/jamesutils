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
            'AddCoastCallback(''AddCoast'')','position',nextbuttoncoords);
        
    case 'AddCoast'
        % find maximum, zoom in       
        
        addstates(gcbf);
    otherwise
        error('syntax error in AddCoastCallBack.m')
        
end
end
