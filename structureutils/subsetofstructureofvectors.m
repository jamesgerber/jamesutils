function b=subsetofstructureofvectors(a,iikeep,stringfields)
% subsetofstructureofvectors - create a subset of structure of vectors
%
% SYNTAX
% b = subsetofstructureofvectors(a,ii) - create copy of a with vectors sampled at
% indices ii
% ignores fields of length 1 or length 9331200 (5 min raster) or 3237023
% (landmasklogical)
%
% b = subsetofstructureofvectors(a,ii,stringfields)  will attempt to turn
% all fields that ARE NOT contained in 'stringfields' into numbers
%
%
% b= subsetofstructureofvectors(a,ii,[])  will attempt to turn all fields
% of a into numbers
%
% b= subsetofstructureofvectors(a,[],[])

if nargin<3
    tryStr2double=0;
else
    warning('have neer tested w2ith 3 inputs')
    tryStr2double=1;
end



fields=fieldnames(a);

if nargin==1
    error('need code to figure out what iikeep is')
    % not trivial - because some fields may be scalar
end


b=a;

if tryStr2double==0
    for j=1:numel(fields)
        thisfield=fields{j};
        thisdata=getfield(a,thisfield);
        
        
        if numel(thisdata)==1
            b=setfield(b,thisfield,thisdata);
        elseif numel(thisdata)==9331200
            b=setfield(b,thisfield,thisdata);
        elseif numel(thisdata)==3237023
            b=setfield(b,thisfield,thisdata);
        else

        
            b=setfield(b,thisfield,thisdata(iikeep));
        end
    end
else
    b=struct;
    
    for j=1:numel(fields)
        
        thisfield=fields{j};
        thisdata=getfield(a,thisfield);
        
        if numel(thisdata)==1
            b=setfield(b,thisfield,thisdata);
        elseif numel(thisdata)==9331200
            b=setfield(b,thisfield,thisdata);
        elseif numel(thisdata)==3237023
            b=setfield(b,thisfield,thisdata);
        else
            
            if ~isempty(strmatch(thisfield,stringfields))
                % there was a match ... don't attempt str2double
                b=setfield(b,thisfield, thisdata(iikeep) );
            else
                % there was no match.
                
                % if this is already a double, don't try str2double - that
                %  ends badly.
                
                if iscell(thisdata)
                    data=str2double( thisdata );
                    b=setfield(b,thisfield, data(iikeep) );
                else
                    b=setfield(b,thisfield,thisdata(iikeep));
                end
                
            end
        end
    end
end
