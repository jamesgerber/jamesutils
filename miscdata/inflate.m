function matrix=inflate(vector,background,mask);
%inflate - turn a vector into a matrix


if nargin==3
    if length(vector) ~= length(find(mask))
        error('mask, vector incompatible');
    end
end

if nargin<2
    background=0;
end

matrix=datablank(background);

switch numel(vector);
    case 2069588
        matrix(agrimasklogical)=vector;
    case 3237023
        matrix(landmasklogical)=vector;
    case 9331200
        
        % seems like a vector was passed in
        matrix=vector;  

    otherwise
        error('don''t know how to inflate this vector')
end

        