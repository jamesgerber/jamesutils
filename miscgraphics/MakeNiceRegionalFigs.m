function [filename,DataResolution,PrintResolution,Region]=MakeNiceRegionalFigs(raster,Region,NSS,filename);
%  MakeNiceRegionalFigs
%
%   MakeNiceRegionalFigs(raster,Region,NSS,filename);
%   MakeNiceRegionalFigs(raster,Region);
%   MakeNiceRegionalFigs(raster,Region,NSS);
%   [filename,DataResolution]=MakeNiceRegionalFigs(...);
%   [filename,DataResolution,PrintResolution,Region]=MakeNiceRegionalFigs(...)
%
%  Some example:
%
%  Region='SouthAmerica'
%  maketransparencymasks_nogridlinesnostates_Regional('r600',Region,'5min');
%
% [long,lat,raster]=processgeotiff(['/Users/jsgerber/DataProducts/ext/HansenTreeCover/HansenTreeCover5min.tif']);
% TreeCover=raster;
%
%  NSS.resolution='-r600';
%  outputfilename=MakeNiceRegionalFigs(TreeCover,Region,NSS,'deleteme.png')
%
%  maketransparentOcReg_noant_nogridlinesnostates_removeislands...
%    (outputfilename,['TreeCover' Region '_' NSS.resolution '.png'],[1 1 1],1,Region,NSS.resolution,'5min');
%
%   [filename,DataResolution,PrintResolution,Region]=MakeNiceRegionalFigs(...)


if nargin==0
    help(mfilename)
    return
end

NSS.mappingtoolbox='off';

global DONOTUSEMAPPINGTOOLBOX
usermappingpreference=DONOTUSEMAPPINGTOOLBOX;

if nargin>2
    % let's remove drawdownNSS fields from here
    dummyNSS=getDrawdownNSS;
    ff=fieldnames(dummyNSS);
    ff=setdiff(ff,'resolution');
    % don't remove resolution
    for j=1:numel(ff);
        f=ff{j};
        if isfield(NSS,f)
            if isequal(NSS.(f),dummyNSS.(f));
                NSS=rmfield(NSS,f);
            end
        end
    end
end

filenamesuffix='';

mappingoff

switch prod(size(raster))
    case [4320*2160]
        DataResolution='5min';
        [g0,g1,g2,g3,g]=getgeo41;
        adminraster=g1.raster1;
    case [8640*4320]
        DataResolution='5km';
        [long,lat,adminraster]=processgeotiff('~/DataProducts/ext/GADM/GADM41/GADM1_A_5km.tif');
    case [43200*21600]
        DataResolution='30sec';
        [long,lat,adminraster]=processgeotiff('~/DataProducts/ext/GADM/GADM41/GADM1_30s.tif');
    otherwise
        error
end




switch Region

    case {'USA','CONUS','conus'}
        Region='CONUS';
        ThisXLim=[-130 -65];
        ThisYLim=[18 51];
        NewPosition=[218   618   560   380];
        countrylist={'USA'};
        [LandMaskIndices]=internalstuff(Region,DataResolution,adminraster,countrylist);



    case {'RUS','Russia'}
        Region='Russia'
        ThisXLim=[30 179];
        ThisYLim=[40 80];
        NewPosition=[218   618   560   380];
        countrylist= {'RUS'};

        %% should functionalize this ... copying and pasting START
        saveRegionalplottingdatafile=['~/Documents/NiceRegionFigsData/' Region 'PlottingData' DataResolution '.mat'];
        if exist(saveRegionalplottingdatafile)==2
            load(saveRegionalplottingdatafile,'LandMaskIndices')
        else
            LandMask=adminraster*0;

            for j=1:numel(countrylist);
                g1=getgeo41_g1(countrylist{j});
                g1.countrynames{1}
                for m=1:numel(g1.uniqueadminunitcode);
                    ii=adminraster==g1.uniqueadminunitcode(m);
                    LandMask(ii)=1;
                end
            end
            LandMaskIndices=find(LandMask);
            save(saveRegionalplottingdatafile,'LandMaskIndices','ThisXLim','ThisYLim')
        end
        %% should functionalize this ... copying and pasting END

   case {'nafta','NAFTA','Nafta'}
        Region='NAFTA'
        ThisXLim=[-170 -55];
        ThisYLim=[15 78];
        NewPosition=[218   618   560   380];
        countrylist= {'USA','CAN','MEX'};

        %% should functionalize this ... copying and pasting START
        saveRegionalplottingdatafile=['~/Documents/NiceRegionFigsData/' Region 'PlottingData' DataResolution '.mat'];
        if exist(saveRegionalplottingdatafile)==2
            load(saveRegionalplottingdatafile,'LandMaskIndices')
        else
            LandMask=adminraster*0;

            for j=1:numel(countrylist);
                g1=getgeo41_g1(countrylist{j});
                g1.countrynames{1}
                for m=1:numel(g1.uniqueadminunitcode);
                    ii=adminraster==g1.uniqueadminunitcode(m);
                    LandMask(ii)=1;
                end
            end
            LandMaskIndices=find(LandMask);
            save(saveRegionalplottingdatafile,'LandMaskIndices','ThisXLim','ThisYLim')
        end
        %% should functionalize this ... copying and pasting END


           case {'USCAN'}
        Region='USCAN'
        ThisXLim=[-170 -55];
        ThisYLim=[15 78];
        NewPosition=[218   618   560   380];
        countrylist= {'USA','CAN'};

        %% should functionalize this ... copying and pasting START
        saveRegionalplottingdatafile=['~/Documents/NiceRegionFigsData/' Region 'PlottingData' DataResolution '.mat'];
        if exist(saveRegionalplottingdatafile)==2
            load(saveRegionalplottingdatafile,'LandMaskIndices')
        else
            LandMask=adminraster*0;

            for j=1:numel(countrylist);
                g1=getgeo41_g1(countrylist{j});
                g1.countrynames{1}
                for m=1:numel(g1.uniqueadminunitcode);
                    ii=adminraster==g1.uniqueadminunitcode(m);
                    LandMask(ii)=1;
                end
            end
            LandMaskIndices=find(LandMask);
            save(saveRegionalplottingdatafile,'LandMaskIndices','ThisXLim','ThisYLim')
        end
        %% should functionalize this ... copying and pasting END

    case {'africa','Africa'}
        Region='Africa'
        ThisXLim=[-20 53];
        ThisYLim=[-55 44];
        NewPosition=[218   246   461   752];
        countrylist= {'ESH',...
    'DZA', 'AGO', 'BEN', 'BWA', 'BFA', 'BDI', 'CPV', 'CMR', 'CAF', ...
    'TCD', 'COM', 'COG', 'COD', 'CIV', 'DJI', 'EGY', 'GNQ', 'ERI', ...
    'SWZ', 'ETH', 'GAB', 'GMB', 'GHA', 'GIN', 'GNB', 'KEN', 'LSO', ...
    'LBR', 'LBY', 'MDG', 'MWI', 'MLI', 'MRT', 'MUS', 'MAR', 'MOZ', ...
    'NAM', 'NER', 'NGA', 'RWA', 'STP', 'SEN', 'SYC', 'SLE', 'SOM', ...
    'ZAF', 'SSD', 'SDN', 'TZA', 'TGO', 'TUN', 'UGA', 'ZMB', 'ZWE' ...
    };

        %% should functionalize this ... copying and pasting START
        saveRegionalplottingdatafile=['~/Documents/NiceRegionFigsData/' Region 'PlottingData' DataResolution '.mat'];
        if exist(saveRegionalplottingdatafile)==2
            load(saveRegionalplottingdatafile,'LandMaskIndices')
        else
            LandMask=adminraster*0;

            for j=1:numel(countrylist);
                g1=getgeo41_g1(countrylist{j});
                g1.countrynames{1}
                for m=1:numel(g1.uniqueadminunitcode);
                    ii=adminraster==g1.uniqueadminunitcode(m);
                    LandMask(ii)=1;
                end
            end
            LandMaskIndices=find(LandMask);
            save(saveRegionalplottingdatafile,'LandMaskIndices','ThisXLim','ThisYLim')
        end
        %% should functionalize this ... copying and pasting END

    case {'sa','SouthAmerica','SA','SAmer','sam'}
        Region='SouthAmerica'
        ThisXLim=[-85 -30];
        ThisYLim=[-70 13];
        NewPosition=[ 509          71         535        1027];
        countrylist={'BRA','PER','BOL','SUR','COL','VEN','GUY','ECU','GUF','CHL','URY','ARG','PRY'};

        %% should functionalize this ... copying and pasting START
        saveRegionalplottingdatafile=['~/Documents/NiceRegionFigsData/' Region 'PlottingData' DataResolution '.mat'];
        if exist(saveRegionalplottingdatafile)==2
            load(saveRegionalplottingdatafile,'LandMaskIndices')
        else
            LandMask=adminraster*0;

            for j=1:numel(countrylist);
                g1=getgeo41_g1(countrylist{j});
                g1.countrynames{1}
                for m=1:numel(g1.uniqueadminunitcode);
                    ii=adminraster==g1.uniqueadminunitcode(m);
                    LandMask(ii)=1;
                end
            end
            LandMaskIndices=find(LandMask);
            save(saveRegionalplottingdatafile,'LandMaskIndices','ThisXLim','ThisYLim')
        end
        %% should functionalize this ... copying and pasting END



    case {'congo','Congo'}
        countrylist = {'COD', 'COG', 'GAB', 'CMR', 'CAF', 'SSD', 'GNQ'};
        Region='Congo';
        saveRegionalplottingdatafile=['~/Documents/NiceRegionFigsData/' Region 'PlottingData' DataResolution '.mat'];

        NewPosition=[218   246   461   752];

        ThisXLim=[-18 53];
        ThisYLim=[-16 16];
        ThisXLim=[-18 51];
        ThisYLim=[-42 38];
        if exist(saveRegionalplottingdatafile)==2
            load(saveRegionalplottingdatafile,'LandMaskIndices')
        else
            LandMask=adminraster*0;

            for j=1:numel(countrylist);
                g1=getgeo41_g1(countrylist{j});
                g1.countrynames{1}
                for m=1:numel(g1.uniqueadminunitcode);
                    ii=adminraster==g1.uniqueadminunitcode(m);
                    LandMask(ii)=1;
                end
            end
            LandMaskIndices=find(LandMask);
            save(saveRegionalplottingdatafile,'LandMaskIndices','ThisXLim','ThisYLim')

        end

    case {'amazon','Amazon'}
%NewPosition=[218   246   461   752];
NewPosition=[218   246   400   752];
        Region='Amazon';


        countrylist={'BRA','PER','BOL','SUR','COL','VEN','GUY','ECU','GUF'};
        saveRegionalplottingdatafile=['~/Documents/NiceRegionFigsData/' Region 'PlottingData' DataResolution '.mat'];

        ThisXLim=[-85 -30];
        ThisYLim=[-58 13];

      if exist(saveRegionalplottingdatafile)==2
            load(saveRegionalplottingdatafile,'LandMaskIndices')
        %       % section to get long/lat extend
        %     [g0,g1,g2,g3,g]=getgeo41;
        %     [~,~,long2,lat2]=inferlonglat(datablank);
        % 
        %     % first get limits.
        %                     Ylower=90;
        %         Yupper=-90;
        %         Xlower=180;
        %         Xupper=-180;
        %     for j=1:numel(countrylist);
        %         [g0,ii]=getgeo41_g0(countrylist{j});
        % 
        % 
        %         Ylower=min(Ylower,min(lat2(ii)));
        %         Yupper=max(Yupper,max(lat2(ii)));
        %         Xlower=min(Xlower,min(long2(ii)));
        %         Xupper=max(Xupper,max(long2(ii)));
        %     end
        % 
        % ThisYLim=[floor(Ylower) ceil(Yupper)]+[-1 1];
        % ThisXLim=[floor(Xlower) ceil(Xupper)]+[-1 1];



        else
            LandMask=adminraster*0;

        for j=1:numel(countrylist);
            g1=getgeo41_g1(countrylist{j});
            g1.countrynames{1}
            for m=1:numel(g1.uniqueadminunitcode);
                ii=adminraster==g1.uniqueadminunitcode(m);
                LandMask(ii)=1;
            end
        end
        LandMaskIndices=find(LandMask);
        save(saveRegionalplottingdatafile,'LandMaskIndices','ThisXLim','ThisYLim')

      end

       
    case {'seasia','southeastasia','sea','apc','SEAsia','SEA'}
      %  NewPosition=[218   618   560   380];
        NewPosition=[762          100         707        955];
Region='SEAsia';
        saveRegionalplottingdatafile=['~/Documents/NiceRegionFigsData/SEAsiaPlottingData' DataResolution '.mat'];
        ThisYLim=[-20, 30];
        ThisXLim=[90 142];

        if exist(saveRegionalplottingdatafile)==2
            load(saveRegionalplottingdatafile)
        else
            disp(['creating land mask'])
            switch DataResolution
                case '5min'
                case '5km'
                    error('oops')
                case '30s'
            end

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
            save(saveRegionalplottingdatafile,'LandMaskIndices')
        end

        filenamesuffix='SEAsia';
    otherwise % country specific
        [g0,g1,g2,g3,g]=getgeo41;
       % NewPosition=[218   618   560   380];

        idx=strmatch(Region,g0.gadm0codes)

        ii=g0.raster0==idx;
        [~,~,long2,lat2]=inferlonglat(datablank);

        ThisYLim=[floor(min(lat2(ii))) ceil(max(lat2(ii)))]+[-1 1];
        ThisXLim=[floor(min(long2(ii))) ceil(max(long2(ii)))]+[-1 1];
      
        NewPosition=[100 100 500 ceil(500*diff(ThisYLim)/diff(ThisXLim))*1.2];
        % add 20% in y because of colorbar
        
        
        
        saveRegionalplottingdatafile=['~/Documents/NiceRegionFigsData/' Region 'PlottingData' DataResolution '.mat'];

        if exist(saveRegionalplottingdatafile)==2
            load(saveRegionalplottingdatafile)
        else
            disp(['creating land mask'])
            [g0,g1,g2,g3,g]=getgeo41;
            adminraster=g1.raster1;

            RegionLandMask=zeros(size(adminraster));
            g1=getgeo41_g1(Region);
            g1.countrynames{1};
            for m=1:numel(g1.uniqueadminunitcode);
                ii=adminraster==g1.uniqueadminunitcode(m);
                RegionLandMask(ii)=1;
            end

            LandMaskIndices=find(RegionLandMask);
            save(saveRegionalplottingdatafile,'LandMaskIndices')
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
raster=double(raster);
raster(LandMask==0)=nan;

if nargin>2

    if isfield(NSS,'logicalinclude');
        tmp=NSS.logicalinclude;
        NSS.logicalinclude=NSS.logicalinclude(ii,jj);
    end
    OS=nsg(long(ii),lat(jj),raster(ii,jj),NSS);
else
    OS=nsg(long(ii),lat(jj),raster(ii,jj));
end

ThisFig=gcf;
% ThisYLim=[-12, 30];
% ThisXLim=[90 142];

% the following code is taken from Import case from propagatelimits.m
set(OS.axishandle,'XLim',ThisXLim);
set(OS.axishandle,'YLim',ThisYLim);
fud=get(ThisFig,'userdata');

y0=ThisYLim(2)
dely=diff(ThisYLim);
x0=mean(ThisXLim);
if isfield(fud,'titlehandle')
    delete(fud.titlehandle);
end

if ~isfield(NSS,'panoplytriangles')
    ht=text(x0,y0+dely*0.05,fud.titlestring);
else
    ht=text(.5,.95,fud.titlestring)
end
set(ht,'FontSize',14)
set(ht,'HorizontalAlignment','center');

set(ht,'FontWeight','Bold');
set(ht,'tag','NSGTitleTag');
fud.titlehandle=ht;
set(ThisFig,'userdata',fud);
UserInterpPreference=callpersonalpreferences('texinterpreter');

set(ht,'interp',UserInterpPreference);

% change position
set(gcf,'Position',NewPosition);

% now can print
filename=strrep(filename,'.png','');
filename=[filename filenamesuffix '.png'];

if isfield(NSS,'resolution')
    outputfig('Force',filename,NSS.resolution);
    PrintResolution=NSS.resolution;
elseif isfield(NSS,'Resolution')
    outputfig('Force',filename,NSS.Resolution);
    PrintResolution=NSS.Resolution;
else
    outputfig('Force',filename,'-r300');
    PrintResolution='-r300';
end
hideui
print(['wtf' filename],'-dpng','-r300')
if usermappingpreference==0
    mappingon
end


function  LandMaskIndices=internalstuff(Region,Resolution,adminraster,countrylist)
saveRegionalplottingdatafile=['~/Documents/NiceRegionFigsData/' Region 'PlottingData' Resolution '.mat'];
if exist(saveRegionalplottingdatafile)==2
    load(saveRegionalplottingdatafile,'LandMaskIndices')
else
    LandMask=adminraster*0;

    for j=1:numel(countrylist);
        g1=getgeo41_g1(countrylist{j});
        g1.countrynames{1}
        for m=1:numel(g1.uniqueadminunitcode);
            ii=adminraster==g1.uniqueadminunitcode(m);
            LandMask(ii)=1;
        end
    end
    LandMaskIndices=find(LandMask);
    save(saveRegionalplottingdatafile,'LandMaskIndices')
end


