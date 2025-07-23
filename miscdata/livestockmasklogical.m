function LogicalVector=livestockmasklogical

persistent LiveStockMaskVector

if isempty(LiveStockMaskVector)
    SystemGlobals
    Data=load([iddstring '/Livestock2000/livestock.mat']);
    Livestock=(Data.livestock2);
    LiveStockMaskVector=(Livestock>0);
end
LogicalVector=LiveStockMaskVector;

end

