function LogicalVector=landmasklogical(DataTemplate)
% LANDMASKLOGICAL - logical array of standard landmask
%
%  Syntax
%
%      LogicalMatrix=LandMaskLogical - returns the 5 minute landmask
%
%      LogicalMatrix=LandMaskLogical(DataTemplate) - returns a landmask of
%        the size of DataTemplate (if DataTemplate is 5 or 10 mins)

persistent LogicalLandMaskVector

if isempty(LogicalLandMaskVector)
    SystemGlobals
    [Long,Lat,Data]=opennetcdf(LANDMASK_5MIN);
    LogicalLandMaskVector=(Data>0);
end

LogicalVector=LogicalLandMaskVector;

if nargin==0
    return
end

% if we are here, it is because a DataTemplate was passed in.

switch numel(DataTemplate)
    case 4320*2160  %5min
        return
    case 2160*1080  %10min
        
        ii=1:2:4319;
        jj=1:2:2159;
        
        LogicalVector10min=...
            (LogicalVector(ii,jj)  | ...
            LogicalVector(ii,jj+1) | ...
            LogicalVector(ii+1,jj) | ...
            LogicalVector(ii+1,jj+1));
        
        LogicalVector=LogicalVector10min;
    case 720*360  %30min / .5 degree
        SystemGlobals
        try
            [Long,Lat,Data]=aOpenNetCDF(LANDMASK_30MIN);
        catch
            warning(' didn''t find LANDMASK_30MIN.  downsampling 5min landmask. ')
            lml=LandMaskLogical;
            Data=lml(1:6:end,1:6:end);
        end
        LogicalVector=(Data>0);
    case 144*72 %2.5 degrees

        lml=LandMaskLogical;
        Data=aggregate_rate(lml,30);     
        LogicalVector=(Data>=0.5);
        
%     case 1080*540
%         lml=LandMaskLogical;
%         data=aggregate_quantity(lml,4);
%         LogicalVector=(data>=0.5);
    case 4320*8640 % 5minute
x=load('~/DataProducts/ext/landmasks/landmask5km.mat');
LogicalVector=x.landmask5km;  % no idea which is is called a vector.

        
    otherwise
        warning('don''t have a landmask at this size.  trying ...')
        lml=EasyInterp2(LandMaskLogical,size(DataTemplate,1),size(DataTemplate,2),'nearest');
        LogicalVector=lml>0.5; 
end




