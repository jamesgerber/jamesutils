function AddStates(LineWidth,HFig,AllStates,latoff,longoff);
%  ADDSTATES - add country boundaries and some state boundaries
%
%  AddStates(0.1)  will add some very thin lines
%
%  AddStates(N) where N is an integer will add lines of default thickness
%  (0.5) to figure N.   [This was added for backwards compatibility]
%
%  AddStates all  will add all state boundaries (gadm 1.0, level 1)
%  AddStates world  will add all state boundaries (gadm 1.0, level 1)
%
%  See Also  AddCoasts

if nargin==0
    HFig=gcf;
    LineWidth=0.5;
    AllStates='bricnafta';
end


if nargin==1 & (isequal(lower(LineWidth),'all') | ...
        isequal(lower(LineWidth),'world'));
    AddStates(0.5,gcf,'all');
    return
end

if nargin==1
    if LineWidth==round(LineWidth)
        % this is a figure handle
        HFig=LineWidth;
        LineWidth=0.5;
    else
        HFig=gcf;
    end
    AllStates='bricnafta';
end

if nargin==2
    AllStates='bricnafta';
end

if nargin<4
    latoff=0;
    longoff=0;
end

StateColor=[.1 .1 .1]*6;
CountryColor=[.1 .1 .1]*0;

switch lower(AllStates)
    case {'bric','bricnafta'}
        AllStatesFlag=0;
    case {'all','world','gadm1'};
        AllStatesFlag=1;
    case {'gadm0'}
        AllStatesFlag=2;
    case {'agplaces'};
        AllStatesFlag=3;
    case {'countrieslight','lightcountries'}
        AllStatesFlag=2;
        CountryColor=[.1 .1 .1]*5;

end


hax=gca;

SystemGlobals

try
    switch AllStatesFlag
        case 0
            Countries=load(WORLDCOUNTRIES_LEVEL0_HIRES);
            States=load(WORLDCOUNTRIES_BRIC_NAFTASTATES_VECTORMAP_HIRES);
        case 1
            Countries=load(WORLDCOUNTRIES_LEVEL0_HIRES);
            States=load(WORLDCOUNTRIES_LEVEL1_HIRES);
        case 2
            Countries=load(WORLDCOUNTRIES_LEVEL0_HIRES);
            States=load(WORLDCOUNTRIES_LEVEL0_HIRES);
        case 3
            Countries=load([iddstring '/AdminBoundary2010/AgPlacesRev1.mat']);
            States.lat=NaN;
            States.long=NaN;
            
            
        otherwise
            error(['Prob with switch statement in ' mfilename ])
    end
    
catch
    disp(['did not find system vectormap'])
    disp(['loading default matlab coasts'])
    load coast
end

holdstatus=ishold;
hold on

try
    CanMap=CheckForMappingToolbox;
catch
    disp(['problem with Mapping Toolbox check in ' mfilename]);
    CanMap=0;
end

%if CanMap==0

if numel(LineWidth)==1
    
    
    if ~ismap(gca)
        hp=plot(States.long+longoff,States.lat+latoff);
        set(hp,'linewidth',LineWidth,'Color',StateColor);
        hq=plot(Countries.long+longoff,Countries.lat+longoff,'k');
        set(hq,'linewidth',LineWidth,'Color',CountryColor)
    else
        hp=plotm(States.lat+latoff,States.long+longoff,'k');
        set(hp,'linewidth',LineWidth,'Color',StateColor);
        hq=plotm(Countries.lat+latoff,Countries.long+longoff,'k');
        set(hq,'linewidth',LineWidth,'Color',CountryColor);
    end
else
    disp(' hacked multi-element linewidth argument');
    
    if ~ismap(gca)
        hp=plot(States.long+longoff,States.lat+latoff);
        set(hp,'linewidth',LineWidth(5),'Color',LineWidth(6:8));
        hq=plot(Countries.long+longoff,Countries.lat+longoff,'k');
        set(hq,'linewidth',LineWidth(1),'Color',LineWidth(2:4));
    else
        hp=plotm(States.lat+latoff,States.long+longoff,'k');
        set(hp,'linewidth',LineWidth(5),'Color',LineWidth(6:8));
        hq=plotm(Countries.lat+latoff,Countries.long+longoff,'k');
        set(hq,'linewidth',LineWidth(1),'Color',LineWidth(2:4));
    end
    
    
    
    
    
end


set(gcf,'renderer','zbuffer');

if holdstatus==0
    hold off
end
axes(gca);
