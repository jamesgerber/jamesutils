function Data=MaskIndicesTo5MinGrid(Data)
% MASKINDICESTO5MINGRID - if user accidentally sends a vector of some sort
% instead of a matrix, try to turn it into a proper global matrix
%
% SYNTAX
% output=MaskIndicesTo5MinGrid(input) - look at common logical masks. If
% the length of input is the same as the number of ones in any of these
% masks, assume that it's a vector of values that are supposed to be
% placed over the ones on that mask. Set output to a global matrix
% containing this data.

if min(size(Data))==1
    % This is a vector.  That's not good.  Either user messed up or
    % user is only sending us the values corresponding to the
    % DataMask
    DML=DataMaskLogical;
    switch(length(Data))
        case numel(DML)
            % user has passed in the entire globe as a vector.
            DML=DML*0;  %Use this matrix
            DML(DMI)=Data(DMI);
            Data=DML;
        case length(DataMaskIndices)
            %user has only sent in data corresponding to datamask
            DML=DML*0;  %now use DML to construct a matrix for DATA
            DML(DataMaskIndices)=Data; %Data still a vector, assign it into DML
            Data=DML;  %now Data is properly embedded in a matrix
        case length(LandMaskIndices)
            %user has only sent in data corresponding to landmask
            DML=DML*0;  %now use DML to construct a matrix for DATA
            DML(LandMaskIndices)=Data; %Data still a vector, assign it into DML
            Data=DML;  %now Data is properly embedded in a matrix
        case length(AgriMaskIndices)
            %user has only sent in data corresponding to agrimask
            DML=DML*0;  %now use DML to construct a matrix for DATA
            DML(AgriMaskIndices)=Data; %Data still a vector, assign it into DML
            Data=DML;  %now Data is properly embedded in a matrix
        case length(CropMaskIndices)
            %user has only sent in data corresponding to cropmask
            DML=DML*0;  %now use DML to construct a matrix for DATA
            DML(CropMaskIndices)=Data; %Data still a vector, assign it into DML
            Data=DML;  %now Data is properly embedded in a matrix
        otherwise
            
            error(['Don''t know what to do with a vector of this length'])
    end
end
