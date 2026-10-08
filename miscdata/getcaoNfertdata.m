function x=getcaoNfertdata(cropname)
% getcaoNfertdata - return fert data

basedir=[DataProductsDir '/ext/Cao_CropGHGs/Input_data_Nfer_intensity'];

CCCC=MonfredaNameToSpamName(cropname);

x=pgt([basedir '/global_crop_Nrate_2020_kg_ha_' CCCC '.tif']);

