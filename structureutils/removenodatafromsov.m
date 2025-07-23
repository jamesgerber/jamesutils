function [SOV]=removenodatafromsov(SOV,verboseflag,nodatavalue,replacevalue);
% removenansfromsov 
%
%  [SOVfinite,OS]=removenansfromsov(SOV);
%  [SOVfinite,OS]=removenansfromsov(SOV,1);   % verbose

if nargin==1
    verboseflag=0;
end

a=fieldnames(SOV);

thisfield=getfield(SOV,a{1});

badindices=logical(zeros(size(thisfield)));   % logical of zeros

for j=1:numel(a);
    
    thisfield=a{j};

    fielddata=getfield(SOV,a{j});
    

    baddata=abs(fielddata) > nodatavalue;
    
    fielddata(baddata)=replacevalue;
    
    numbad(j)=numel(find(baddata));
    
    if numbad(j)
        % possible place for breakpoint
        5;
    end
    
    if verboseflag==1
       fprintf(1,'%10d bad indices in field %s\n',numbad(j),a{j});        
    end
    
    
    SOV=setfield(SOV,thisfield,fielddata);
end   


