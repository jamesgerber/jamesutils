function cropindexallmatrices
% CROPINDEXALLMATRICES - Turn all 4320X2160 matrices to crop index vectors 
%
%
%   Syntax
%       cropindexallmatrices with no arguments will examine all variables
%       in the calling workspace and look for matrices that are 4320x2160.
%       It will replace any such matrix X with a vector X_cropindex 


% JSG
% Institute on the Environment
% October, 2009

a=evalin('caller','whos');
for j=1:length(a);
    if  isequal(a(j).size,[4320 2160])
        disp([' found a matrix ']);
        a(j).name
        evalin('caller',[a(j).name '_cropindexvector' '=' a(j).name '(cropmasklogical);']);
        evalin('caller',[ 'clear ' a(j).name ]);
    end
    
%     if isequal(a(j).class,'struct')
%         disp(['found a struct.  inflating.']);
%         evalin('caller',['cropindexastructure(' a(j).name ');']);
%     end
    
end
