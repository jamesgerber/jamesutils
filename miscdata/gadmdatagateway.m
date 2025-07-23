function GADMStats=GADMDataGateway(FAO3);
%  GADMDATAGATEWAY - call to GADM data
%
%  SYNTAX
%
%   GadmStats=GADMDataGateway('FRA');
%
%   GadmStats=GADMDataGateway({'FRA','AFG'});
%% to do - make reduced set of GADM without X Y since those are huge

persistent S ISO3List
if isempty(S)
  SystemGlobals
  load([IoneDataDir '/misc/gadm1_lev0.mat']);
  
  for j=1:length(S);
    ISO3List{j}=S(j).ISO;
  end
end

if isstr(FAO3)
  FAO3={FAO3};
end

for j=1:length(FAO3)
  k=strmatch(FAO3{j},ISO3List);
  if isempty(k)
    warning(['don''t recognize ' FAO3{j}]);
  else
    
    Stmp=S(k);
    Stmp=rmfield(Stmp,'X');
    Stmp=rmfield(Stmp,'Y');  
    GADMStats(j)=  Stmp;
  end
end


