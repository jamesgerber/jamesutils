function LogicalVector=AgriMaskLogical(DataTemplate);
% AGRIMASKLOGICAL -  logical array of standard (5 min) landmask

if nargin==0
    N=9331200;
else
    N=numel(DataTemplate);
end

persistent AgriLandMaskVector Numelements

if isempty(AgriLandMaskVector) | Numelements~=N
    switch N
        case 9331200
            SystemGlobals
            [Long,Lat,Data]=OpenNetCDF(LANDMASK_5MIN);
            AgriLandMaskVector=(Data==7 | Data==3);
        case 37324800
           SystemGlobals
            [Long,Lat,Data]=OpenNetCDF(LANDMASK_5MIN);
            tmp=(Data==7 | Data==3);
            tmp2=disaggregate_rate(tmp,2);
            AgriLandMaskVector=logical(tmp2);
    end

Numelements=N;

end
LogicalVector=AgriLandMaskVector;



