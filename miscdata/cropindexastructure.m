function cropindexastructure(struct)
% CROPINDEXASTRUCTURE - Turn all 4320X2130 matrices to crop index vectors 
%
%
%   Syntax
%       cropindexastructure  
%
%       This is a development tool: it is a bad idea to use this within any
%       function or script.


% JSG
% Institute on the Environment
% October, 2009

stash struct

fieldnames=expandstructure(struct);
clear struct
cropindexallmatrices
unstash struct
a=eval('whos');


for j=1:length(a);
    if  isequal(a(j).size,[4320 2160])
        disp([' found a matrix ']);
        a(j).name
        evalin('caller',[a(j).name '_cropindexvector' '=' a(j).name '(cropmasklogical);']);
        evalin('caller',[ 'clear ' a(j).name ]);
    end
    
    if isequal(a(j).class,'struct')
        disp(['found a struct.  inflating.']);
        evalin('caller',['cropindexastructure(' a(j).name ');']);
    end
    
end
