function OS=CalculateTotalProduction(croplist)
% CalculateTotalProduction
%
%   SYNTAX:
%    OS=CalculateTotalProduction will calculate production for all crops
%
%    OS=CalculateTotalProduction(croplist) will calculate production only
%    for crops in croplist.

C=ReadGenericCSV([iddstring '/misc/cropdata.csv']);
a=dir([iddstring '/misc/cropdata.csv']);
cropnames=C.CROPNAME;

if nargin==0
    try
        %
        load([iddstring '/misc/TotalCropProductionData.mat'],'OS');
        
        if a.datenum > OS.cropdata_datenum
            disp(['cropdata.csv more recent than saved file.  rerunning'])
        else
            return
        end
    catch
        disp(['unable to read ' iddstring '/misc/TotalCropProductionData.mat']);
        disp(['or it is out of date.  going to calculate it again.']);
    end
end

if nargin==0
    cl=C.CROPNAME;
else
    
    % first make sure it's a cell array
    if ischar(croplist)
        croplist={croplist};
    end
    
    %     warning([' i think there is a bug here ... need to add code to ' ...
    %         ' correctly match crop characteristics with crop.  ' ...
    %         'see, perhaps, CalculateTotalPotentialProduction '])
    
    % commenting out that warning because I checked total results for
    
    cl=croplist;
end


SumDryProduction=DataBlank;
SumProduction=DataBlank;
SumArea=DataBlank;
SumNPP=DataBlank;
SumNonHarvestedDryProduction=DataBlank;

fma=GetFiveMinGridCellAreas;

for j=1:length(cl)
    %
    crop=cl{j}
    ii=strmatch(crop,cropnames,'exact');

    if length(ii)~=1
        error('don''t recognize this crop in the croplist')
    end
    
    
    DryFraction=C.Dry_Fraction(ii);
    HarvestIndex=C.Harvest_Index(ii);
    AboveGroundFraction=C.Aboveground_Fraction(ii);
    S=OpenNetCDF([iddstring '/Crops2000/crops/' cl{j} '_5min.nc']);
    Area=S.Data(:,:,1);
    Yield=S.Data(:,:,2);
    
    DataMask=(Area > 0 & isfinite(Area.*Yield) & Area < 9e19 & Yield < 9e19);
    
    SumProduction(DataMask)=SumProduction(DataMask)+...
        Area(DataMask).*Yield(DataMask).*fma(DataMask);
    SumDryProduction(DataMask)=SumDryProduction(DataMask)+...
        Area(DataMask).*Yield(DataMask).*fma(DataMask)*DryFraction;
    
    % this is not a well-supported calculation.  0.2 is an estimate for
    % average dry fraction of plant matter.
    SumNonHarvestedDryProduction(DataMask)=SumNonHarvestedDryProduction(DataMask)+...
        Area(DataMask).*Yield(DataMask).*fma(DataMask).*(1/HarvestIndex-1)*0.2;
    
    SumNPP(DataMask)=SumNPP(DataMask) + ...
        Area(DataMask).*Yield(DataMask).*fma(DataMask).*DryFraction.*0.45 ...
        / ...
        (HarvestIndex.*AboveGroundFraction);
    
    SumArea(DataMask)=SumArea(DataMask)+Area(DataMask);
    
    ProductionVector(j)=sum(Area(DataMask).*Yield(DataMask).*fma(DataMask));
    DryProductionVector(j)=sum(Area(DataMask).*Yield(DataMask).*fma(DataMask)*DryFraction);
  %  NonHarvestedDryProductionVector=sum(...
  %      Area(DataMask).*Yield(DataMask).*fma(DataMask).*(1/HarvestIndex-1)*0.2);
    NameVector{j}=cl{j};
end

OS.SumProduction=SumProduction;
OS.SumDryProduction=SumDryProduction;
OS.SumArea=SumArea;
OS.SumNPP=SumNPP;
%OS.SumNonHarvestedDryProduction=SumNonHarvestedDryProduction;


OS.ProductionVector=ProductionVector;
OS.DryProductionVector=DryProductionVector;
%OS.NonHarvestedDryProductionVector=NonHarvestedDryProductionVector;
% only save if nargin==0

%OS.TotalNPPVector=(NonHarvestedDryProductionVector+DryProductionVector);
%OS.SumTotalNPP=(SumDryProduction+SumNonHarvestedDryProduction)*0.45;


if nargin==0
    
    OS.cropdata_datestamp=a.date;
    OS.cropdata_datenum=a.datenum;
    OS.NameVector=NameVector;
    
    save savingPlotTotalProductionWorkspace
    save([iddstring '/misc/TotalCropProductionData.mat'],'OS');
end
