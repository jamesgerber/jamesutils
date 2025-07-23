function [LogicalInclude,FilteredData,AreaCutoff]=AreaFilter(AreaFraction,Data,p)
%  AreaFilter  - Filter out data below cumulative percentage of area
%
%   SYNTAX:
%
%
%      [LogicalInclude]=AreaFilter(AreaFraction); returns logical array
%      corresponding to points to be included inside area filter
%
%      [LogicalInclude]=AreaFilter(AreaFraction,p)
%
%      [LogicalInclude,FilteredData]=AreaFilter(AreaFraction,Data); will
%      choose an area cutoff AC such that inclusion of all grid cells with
%      cultivated area greater than or equal to AC comprises 95% of all
%      cultivated area.   p=1 means there is no filtering.
%
%      [LogicalInclude,FilteredData,AreaCutoff]=...
%         AreaFilter(AreaFraction,Data,p);
%
%   EXAMPLE:
%  
%  SystemGlobals
%   S=OpenNetCDF([IoneDataDir '/Crops2000/crops/maize_5min.nc'])
% 
%   Area=S.Data(:,:,1);
%   Yield=S.Data(:,:,2);
%    [LogicalInclude90,FilteredYield]=AreaFilter(Area,Yield,0.90);
%NiceSurf(FilteredYield,'Yield Maize 90','tons/ha',[0 12],'revsummer','90')
%    [LogicalInclude95,FilteredYield]=AreaFilter(Area,Yield,0.95);
%NiceSurf(FilteredYield,'Yield Maize 95','tons/ha',[0 12],'revsummer','95')
%    [LogicalInclude50,FilteredYield]=AreaFilter(Area,Yield,0.5);
%NiceSurf(FilteredYield,'Yield Maize 50','tons/ha',[0 12],'revsummer','50')
%    [LogicalInclude50,FilteredYield]=AreaFilter(Area,Yield,1);
%NiceSurf(FilteredYield,'Yield Maize 100','tons/ha',[0 12],'revsummer','100')
%
%

if nargin==0
    help(mfilename)
    return
end

switch nargin
    case 1
        Data=AreaFraction;
        p=0.95;
    case 2
        if numel(Data)==1
            p=Data;
            Data=AreaFraction;
        else
            p=0.95;
        end
end

ii=(AreaFraction)<8.9e9;

if nanmax(nanmax(AreaFraction(ii)))>2
    disp(['This appears to be actual area, not area fraction'])
    CultivatedArea=AreaFraction;
else
    [Long,Lat,FiveMinGridCellAreas]=GetFiveMinGridCellAreas;
    CultivatedArea=AreaFraction.*FiveMinGridCellAreas;
end



ii=isfinite(Data) & abs(Data) < 8.9e9 & CultivatedArea>0 & (AreaFraction)<8.9e9;

AV=CultivatedArea(ii);  %AreaValues
AVsort=sort(AV);

cumulativeAV=cumsum(AVsort);
cAVnorm=cumulativeAV/max(cumulativeAV);
[iiAV]=min(find(cAVnorm>=(1-p)));
AreaCutoff=AVsort(iiAV);

LogicalInclude=(ii & CultivatedArea>=AreaCutoff);
FilteredData=Data;
FilteredData(~LogicalInclude)=NaN;



if nargout==0
    figure
    subplot(211)
    [N,x]=hist(AVsort,1000);
    bar(x,N,.2)
    zeroxlim(0,1000)
    xlabel('grid cell area')
    ylabel('histogram')
    grid on
    hold on
    ylims=get(gca,'YLim')
    plot([1 1]*AreaCutoff,ylims,'r');
    hold off
    title(['    Distribution of grid cell areas    '])
    
    
    
    subplot(212)
    plot(AVsort,cAVnorm)
    zeroxlim(0,1000)
    xlabel('grid cell area')
    ylabel('Cumulative area')
    title(['    Cumulative area    '])
    hold on
    ylims=get(gca,'YLim')
    plot([1 1]*AreaCutoff,ylims,'r');
    grid on
    fattenplot
    
end

function [varargout] = nanmax(varargin)
[varargout{1:nargout}] = max(varargin{:});

%