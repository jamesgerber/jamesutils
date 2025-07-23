function [SOVfinite,Output]=removenansfromsov(SOV,verboseflag);
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
    switch thisfield
        case {'Population2015','DixonCodes_SSA'}
            
            disp([' not rejecting for ' thisfield]);
        otherwise

    fielddata=getfield(SOV,a{j});
    
    badindices=badindices | ~isfinite(fielddata);
    
    numbad(j)=numel(find(~isfinite(fielddata)));
    
    if numbad(j)>0
        % good place for breakpoint
        0;
    end
    
    if verboseflag==1
       fprintf(1,'%10d bad indices in field %s\n',numbad(j),a{j});        
    end
    end
    
end   


Output.fieldnames=a;
Output.numbad=numbad;
Output.keepindices=~badindices;


disp([ num2str(numel(find(badindices))) ' non-finite elements out of ' num2str(numel(fielddata))]);

SOVfinite=subsetofstructureofvectors(SOV,~badindices);
