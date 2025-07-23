function maketransparencymasks_nogridlinesnostates_Regional(res,Region,MatrixTemplateSize)
% maketransparencymasks - make masks of figure areas to make transparent
%
%   This function makes some necessary masks to allow us to make
%   transparent backgrounds using maketransparentoceans.
%
% SYNTAX
% maketransparencymasks(res) - make transparency masks at the specified
% resolution ('r150', 'r300', 'r600', or 'r1200' dpi).  If res is
% unspecified, make at all available resolutions.
%
%  This can be called automatically by maketransparentoceans, or you can
%  call it from the commandline without arguments
if nargin==0
    maketransparencymasks_nogridlinesnostates_Regional('r150');
    maketransparencymasks_nogridlinesnostates_Regional('r300');
    maketransparencymasks_nogridlinesnostates_Regional('r400');
    maketransparencymasks_nogridlinesnostates_Regional('r500');
    maketransparencymasks_nogridlinesnostates_Regional('r300','SEAsia','5min');
    close all
    maketransparencymasks_nogridlinesnostates_Regional('r600','SEAsia','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r600','SEAsia','30sec');
    maketransparencymasks_nogridlinesnostates_Regional('r1200','SEAsia','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r1200','SEAsia','30sec');
    maketransparencymasks_nogridlinesnostates_Regional('r600','BRA','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r600','Amazon','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r600','Amazon','30sec');
    maketransparencymasks_nogridlinesnostates_Regional('r1200','BRA','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r1200','BRA','30sec');
    maketransparencymasks_nogridlinesnostates_Regional('r300','CONUS','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r300','CONUS','30sec');
    close all
    maketransparencymasks_nogridlinesnostates_Regional('r600','CONUS','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r600','CONUS','30sec');
    maketransparencymasks_nogridlinesnostates_Regional('r600','USA','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r600','USA','30sec');

    close all
    maketransparencymasks_nogridlinesnostates_Regional('r600','THA','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r600','THA','30sec');
close all
    maketransparencymasks_nogridlinesnostates_Regional('r600','IND','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r600','IND','30sec');

close all
    maketransparencymasks_nogridlinesnostates_Regional('r600','VNM','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r600','VNM','30sec');

close all
    maketransparencymasks_nogridlinesnostates_Regional('r600','PHL','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r600','PHL','30sec');
close all
    maketransparencymasks_nogridlinesnostates_Regional('r600','KHM','5min');
    maketransparencymasks_nogridlinesnostates_Regional('r600','KHM','30sec');

    return
end
ii=datablank(1,MatrixTemplateSize);;

NSS.cmap=0*ones(size(colormap));%[1 1 1; 1 1 1];



% lines of code to make sure there is a directory for the masks.

datares=MatrixTemplateSize;
if exist([iddstring '/misc/masknewgen']) ~=7
    warndlg(['creating directory '  iddstring '/misc/masknewgen'])
    mkdir([iddstring '/misc/masknewgen'])
end



NSS.Resolution=['-' res];

outputfilename=MakeNiceRegionalFigs(ii,Region,NSS,'testfile.png');
% first make a file so we know the size
%       nsg(landmasklogical,'filename','testfile.png','resolution',NSS.Resolution);
a=imread(outputfilename);
unix(['rm ' outputfilename]);
close

filesize=['size' num2str(size(a,1)) '_' num2str(size(a,2))];


ver=version;
VerNo=ver(1)
vs=['ver' VerNo '_'];  % ' vs '
FileName=[iddstring '/misc/masknewgen/OutputMask_colorbar_' Region '_' datares '_' filesize 'nogridnostates.png'];
FileNameWithStates=[iddstring '/misc/masknewgen/OutputMask_colorbarWithStateLines_' Region '_' datares '_' filesize 'nogridnostates.png'];
FileNameNCB=[iddstring '/misc/masknewgen/OutputMask_nocolorbar_'  Region '_' datares  '_' filesize 'nogridnostates.png'];
FileNameOceans=[iddstring '/misc/masknewgen/OutputMask_oceans_'  Region '_' datares  '_' filesize 'nogridnostates.png'];
FileNameAgriMask=[iddstring '/misc/masknewgen/OutputMask_agrimask_'  Region '_' datares  '_' filesize 'nogridnostates.png'];
FileNamePT=[iddstring '/misc/masknewgen/OutputMask_PT_'  Region '_' datares  '_' filesize 'nogridnostates.png'];  % panoply triangles
FileNamePTL=[iddstring '/misc/masknewgen/OutputMask_PTL_'  Region '_' datares  '_' filesize 'nogridnostates.png'];  % panoply triangles
FileNamePTR=[iddstring '/misc/masknewgen/OutputMask_PTR_'  Region '_' datares  '_' filesize 'nogridnostates.png'];  % panoply triangles


if exist(FileNameAgriMask)==2
disp(['Appear to have all of the goodies, exiting'])
disp('had this one:')
disp(FileNameAgriMask)

return
 end

MaxNumFigs=callpersonalpreferences('maxnumfigsNSG');


if getnumionesurffigs > MaxNumFigs
    warndlg('too many figures currently open.')
    error('too many figures currently open.')
end

% Figure that is white everywhere
NSS.cmap=0*ones(size(colormap));
NSS.plotstates='off';
NSS.longlatlines='off';
MakeNiceRegionalFigs(ii,Region,NSS,'deleteme.png');
% NSG(ii,NSS)
fud=get(gcf,'userdata')
set(fud.ColorbarHandle,'XTick',[]);
OutputFig('Force',FileName,NSS.Resolution);
close

NSS=rmfield(NSS,'plotstates');
MakeNiceRegionalFigs(ii,Region,NSS,'deleteme.png');
% NSG(ii,NSS)
fud=get(gcf,'userdata')
set(fud.ColorbarHandle,'XTick',[]);
OutputFig('Force',FileNameWithStates,NSS.Resolution);
close

%NSG(ii,NSS)
MakeNiceRegionalFigs(ii,Region,NSS,'deleteme.png');

fud=get(gcf,'userdata')
set(fud.ColorbarHandle,'Visible','off')
OutputFig('Force',FileNameNCB,NSS.Resolution);




% now the only oceans colormap
NSS.cmap=ones(size(colormap));
fud=get(gcf,'userdata')
set(fud.ColorbarHandle,'Visible','off')
set(fud.ColorbarHandle,'XTick',[]);
close

%panoply triangles
%NSG(ii,'cmap',NSS.cmap*0,'resolution',NSS.Resolution,'panoplytriangles',[1 1])
TSS=NSS;
TSS.cmap=NSS.cmap*0;
TSS.resolution=NSS.Resolution;
TSS.panoplytriangles=[1 1];
MakeNiceRegionalFigs(ii,Region,TSS,'deleteme.png')

fud=get(gcf,'userdata')
set(fud.ColorbarHandle,'XTick',[]);
%set(fud.ColorbarHandle,'Visible','off')
OutputFig('Force',FileNamePT,NSS.Resolution);
close

% %panoply triangles
% NSG(ii,'cmap',NSS.cmap*0,'resolution',NSS.Resolution,'panoplytriangles',[1 0])
% fud=get(gcf,'userdata')
% set(fud.ColorbarHandle,'XTick',[]);
% %set(fud.ColorbarHandle,'Visible','off')
% OutputFig('Force',FileNamePTL,NSS.Resolution);
% close
%
% %panoply triangles
% NSG(ii,'cmap',NSS.cmap*0,'resolution',NSS.Resolution,'panoplytriangles',[0 1])
% fud=get(gcf,'userdata')
% set(fud.ColorbarHandle,'XTick',[]);
% %set(fud.ColorbarHandle,'Visible','off')
% OutputFig('Force',FileNamePTR,NSS.Resolution);
% close


%NSG(1-ii,NSS,'lowercolor','black')
NSS.lowercolor='black';
MakeNiceRegionalFigs(ii,Region,NSS,'deleteme.png')

fud=get(gcf,'userdata')
set(fud.ColorbarHandle,'XTick',[]);
OutputFig('Force',FileNameOceans,NSS.Resolution);
close
% now the agri-mask colormap

ii=AgriMaskLogical;
jj=LandMaskLogical;
kk=(jj & ~ii);
k=double(kk);
k(k==1)=NaN;

NSS.lowercolor='black';
NSS.uppercolor='black';
MakeNiceRegionalFigs(ii,Region,NSS,'deleteme.png')
%NSG(k,NSS,'lowercolor','black','uppercolor','black')
fud=get(gcf,'userdata')

set(fud.ColorbarHandle,'Visible','off')
set(fud.ColorbarHandle,'XTick',[]);

OutputFig('Force',FileNameAgriMask,NSS.Resolution);
close