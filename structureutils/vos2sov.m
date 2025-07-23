function SOV=vos2sov(S)
% VOS2SOV - Vector of Structures to Structure of Vectors
%
% SYNTAX
% vos2sov(S) - S is a vector of structures.  Returns a structure of vectors
% with the same length as the length of S, where each vector represents one
% of the common attributes of S's structures.
%
% See also sov2vos


a=fieldnames(S);

for j=1:length(a);
    
    x=getfield(S(1),a{j});
    
    if ischar(x)==1
        TypeFlag(j)=1;
    elseif numel(x) > 1
        TypeFlag(j)=0;
    else
        TypeFlag(j)=2;
    end
end

% TypeFlag=0: ignore
% TypeFlag=1: character
% TypeFlag=2: number

 
SOV=[];
for m=1:length(a)
    ThisField=a{m};
    clear ThisVect
    if TypeFlag(m)>0
        for j=1:length(S)
            if TypeFlag(m)==1
                ThisVect{j}=getfield(S(j),ThisField);
            else
                tmp=getfield(S(j),ThisField);
                % if isempty(tmp)
                %    ThisVect(j)=0;
                %else
                ThisVect(j)=tmp;
                %end
                
            end
        end
        SOV=setfield(SOV,ThisField,ThisVect);
    end
end


    
    