function Integer=ascii2integer(str);
% ASCII2Integer - turn a string into a unique integer. 
%
%   Syntax
%
%   ASCII2Integer(string)
%
%   Will return a unique integer.  string can only be about 7 characters
%   long.

if ~ischar(str)
    % it's not a string.  let's accept a cell array.
    if iscell(str)
        for j=1:length(str)
            Integer(j)=ascii2integer(char(str{j}));
            if length(unique(Integer(1:j)))~=length(unique(str(1:j)))
                error(' vector of integers was not unique' )
            end
        end
        

       
       return
        
        
        
    else
        error(['This doesn''t appear to be a string or a cell array of' ...
            ' strings']);
    end
end


if numel(str)>7
    str=[str(1:2:7) str(end:-2:end-2)];
end

LookupVector=char(0:255);

HexExpression='a';  %make sure it is a character, otherwise the following
%gets screwed up

for j=1:length(str)
    ii=findstr(str(j),LookupVector);

    if isempty(ii)
        % here's some super weird case that arose only when I updated to R2022b
        % there's something that looks like a space but has ascii value 65279
        ii=65279; 
    end
    HexVal=dec2hex(ii);
    HexExpression([2*j-1 2*j])=HexVal(1:2);
end

Integer=uint64(hex2dec(HexExpression));
if Integer == uint64(1e90)
    error('Overflow in ASCII2Integer')
end