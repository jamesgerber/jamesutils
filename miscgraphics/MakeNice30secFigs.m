function MakeNice30secFigs(raster,Region,NSS,filename);
%  MakeNice30secFigs
%
%   MakeNice30secFigs(raster,Region,NSS,filename);
%   MakeNice30secFigs(raster,Region);
%   MakeNice30secFigs(raster,Region,NSS);
%

 global DONOTUSEMAPPINGTOOLBOX
 usermappingpreference=DONOTUSEMAPPINGTOOLBOX;

if nargin==0
    help(mfilename)
    return
end

if nargin>2
    % let's remove drawdownNSS fields from here
    dummyNSS=getDrawdownNSS;
    ff=fieldnames(dummyNSS);
    for j=1:numel(ff);
        f=ff{j};
        if isfield(NSS,f)
            if isequal(NSS.(f),dummyNSS.(f));
                NSS=rmfield(NSS,f);
            end
        end
    end
end

mappingoff

switch Region
    case {'seasia','southeastasia','sea','apc'}

        save30secplottingdatafile='~/Documents/SEAsiaPlottingData30sec.mat';
        ThisYLim=[-12, 30];
        ThisXLim=[90 142];

        if exist(save30secplottingdatafile)==2
            load(save30secplottingdatafile)
        else
            disp(['creating land mask'])
            [g0,g1,g2,g3,g]=getgeo41;
            [long,lat,adminraster]=processgeotiff('~/DataProducts/ext/GADM/GADM41/GADM1_30s.tif');
            SEAsiaLandMask=zeros(size(adminraster));
            for j=1:11
                g1=getgeo41_g1(SEAsia11(j));
                g1.countrynames{1};
                for m=1:numel(g1.uniqueadminunitcode);
                    ii=adminraster==g1.uniqueadminunitcode(m);
                    SEAsiaLandMask(ii)=1;
                end
            end
            LandMaskIndices=find(SEAsiaLandMask);
            save(save30secplottingdatafile,'LandMaskIndices')
        end
    
    otherwise % country specific 
        [g0,g1,g2,g3,g]=getgeo41;

        idx=strmatch(Region,g0.gadm0codes)

       ii=g0.raster0==idx;
       [~,~,long2,lat2]=inferlonglat(datablank);

       ThisYLim=[floor(min(lat2(ii))) ceil(max(lat2(ii)))]+[-1 1];
       ThisXLim=[floor(min(long2(ii))) ceil(max(long2(ii)))]+[-1 1];
                save30secplottingdatafile=['~/Documents/' Region 'PlottingData30sec.mat'];

        if exist(save30secplottingdatafile)==2
            load(save30secplottingdatafile)
        else
            disp(['creating land mask'])
            [g0,g1,g2,g3,g]=getgeo41;
            [long,lat,adminraster]=processgeotiff('~/DataProducts/ext/GADM/GADM41/GADM1_30s.tif');

            RegionLandMask=zeros(size(adminraster));
                g1=getgeo41_g1(Region);
                g1.countrynames{1};
                for m=1:numel(g1.uniqueadminunitcode);
                    ii=adminraster==g1.uniqueadminunitcode(m);
                    RegionLandMask(ii)=1;
                end

            LandMaskIndices=find(RegionLandMask);
            save(save30secplottingdatafile,'LandMaskIndices')
        end

        filenamesuffix=Region;

        if numel(idx)==0;
            error('do not know this region');
        end

end

[long,lat]=inferlonglat(raster);

ii=long>= ThisXLim(1) & long<=ThisXLim(2);
jj=lat > ThisYLim(1) & lat <= ThisYLim(2);

LandMask=zeros(size(raster));
LandMask(LandMaskIndices)=1;
raster(LandMask==0)=nan;

if nargin>2
    nsg(long(ii),lat(jj),raster(ii,jj),NSS);
else
    nsg(long(ii),lat(jj),raster(ii,jj));
end




ThisFig=gcf;
% ThisYLim=[-12, 30];
% ThisXLim=[90 142];
fud=get(ThisFig,'UserData');
% the following code is modified from Import case from propagatelimits.m
set(fud.DataAxisHandle,'XLim',ThisXLim);
set(fud.DataAxisHandle,'YLim',ThisYLim);
%set(gca,'XLim',ThisXLim);
%set(gca,'YLim',ThisYLim);
 
        % the following code is taken from Import case from propagatelimits.m

        y0=ThisYLim(2)
        dely=diff(ThisYLim);
        x0=mean(ThisXLim);
        if isfield(fud,'titlehandle')
            delete(fud.titlehandle);
        end
        ht=text(x0,y0+dely*0.05,fud.titlestring);
        set(ht,'FontSize',14)
        set(ht,'HorizontalAlignment','center');
        
        set(ht,'FontWeight','Bold');
        set(ht,'tag','NSGTitleTag');
        fud.titlehandle=ht;
        set(ThisFig,'userdata',fud);
        UserInterpPreference=callpersonalpreferences('texinterpreter');
        
        set(ht,'interp',UserInterpPreference);



% now can print
hideui
outputfig('Force',filename,'-r600');
if usermappingpreference==0
mappingon
end