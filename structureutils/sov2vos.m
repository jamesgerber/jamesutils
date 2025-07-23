function VOS=sov2vos(DS,ii)
% SOV2VOS -  Structure of Vectors to Vector of Structures
%
% SYNTAX
% SOV2VOS(DS) - DS is a single structure made up of several vectors.  This
% function returns a vector of structures S, where the length of S equals
% the length of the fields of DS.
%
% SOV2VOS(DS,indexlist) - DS is a single structure made up of several vectors.  This
% syntax will only consider the indices ii of the vectors in DS
%
%
% See also vos2sov

a=fieldnames(DS);




for j=1:length(a);
    
    x=getfield(DS,a{j});
    
    switch(class(x))
        case {'double','single'}
            TypeFlag(j)=1;
        case 'char'
            TypeFlag(j)=2;
        case 'cell'
            TypeFlag(j)=3;
        case 'logical'
            TypeFlag(j)=4;
        otherwise
            class(x)
    end
end


if nargin==1
    ii=1:length(x);
end

if islogical(ii)
    ii=find(ii);
end
for mcount=1:length(ii);
    m=ii(mcount);
    S=[];
    for j=1:length(a);
        
        switch TypeFlag(j)
            case {1,4}
                y=getfield(DS,a{j});
                S=setfield(S,a{j},y(m));
            case {2,3}
                y=getfield(DS,a{j});
                S=setfield(S,a{j},y{m});
        end
    end
    
    Svect(mcount)=S;
end
    
VOS=Svect;
        
% 
%  
% SOV=[];
% for m=1:length(a)
% 
%     ThisField=a{m};
%     
%     if TypeFlag(m)>0
%         for j=1:length(S)
%             if TypeFlag==1
%                 ThisVect{j}=getfield(S(j),ThisField);
%             else
%                 ThisVect(j)=getfield(S(j),ThisField);
%             end
%         end
%     SOV=setfield(SOV,ThisField,ThisVect);
%     end
%     end


    
    