function maketransparencymasks_explicitnames(res)
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
   maketransparencymasks('r150');
   maketransparencymasks('r300');
   maketransparencymasks('r400');
   maketransparencymasks('r500');
   maketransparencymasks('r600');
   maketransparencymasks('r1200');
   return
end
ii=datablank;

NSS.cmap=0*ones(size(colormap));%[1 1 1; 1 1 1];

res

% lines of code to make sure there is a directory for the masks.


if exist([iddstring '/misc/mask']) ~=7
    warndlg(['creating directory '  iddstring '/misc/mask'])
    mkdir([iddstring '/misc/mask'])
end

% switch res
%     case 'r150';        
%         NSS.Resolution='-r150';
%         FileName=[iddstring '/misc/mask/OutputMask_colorbar_r150.png'];
%         FileNameNCB=[iddstring '/misc/mask/OutputMask_nocolorbar_r150.png'];
%         FileNameOceans=[iddstring '/misc/mask/OutputMask_oceans_r150.png'];
%         FileNameAgriMask=[iddstring '/misc/mask/OutputMask_agrimask_r150.png'];
% 
%     case 'r300';        
%         NSS.Resolution='-r300';
%         FileName=[iddstring '/misc/mask/OutputMask_colorbar_r300.png'];
%         FileNameNCB=[iddstring '/misc/mask/OutputMask_nocolorbar_r300.png'];
%         FileNameOceans=[iddstring '/misc/mask/OutputMask_oceans_r300.png'];
%         FileNameAgriMask=[iddstring '/misc/mask/OutputMask_agrimask_r300.png'];
%     case 'r600';        
%         NSS.Resolution='-r600';
%         FileName=[iddstring '/misc/mask/OutputMask_colorbar_r600.png'];
%         FileNameNCB=[iddstring '/misc/mask/OutputMask_nocolorbar_r600.png'];
%         FileNameOceans=[iddstring '/misc/mask/OutputMask_oceans_r600.png'];
%         FileNameAgriMask=[iddstring '/misc/mask/OutputMask_agrimask_r600.png'];
%    case 'r1200';        
%         NSS.Resolution='-r1200';
%         FileName=[iddstring '/misc/mask/OutputMask_colorbar_r1200.png'];
%         FileNameNCB=[iddstring '/misc/mask/OutputMask_nocolorbar_r1200.png'];
%         FileNameOceans=[iddstring '/misc/mask/OutputMask_oceans_r1200.png'];
%         FileNameAgriMask=[iddstring '/misc/mask/OutputMask_agrimask_r1200.png'];
% 
%     otherwise
%         disp('warning ... using a new resolution ... making masks')
        NSS.Resolution=['-' res];
        
        
        % first make a file so we know the size
        nsg(landmasklogical,'filename','testfile.png','resolution',NSS.Resolution);
        a=imread('testfile.png');
        !rm testfile.png
        close
        
        res=['size' num2str(size(a,1)) '_' num2str(size(a,2))];
       
        
        ver=version;
        VerNo=ver(1)
        vs=['ver' VerNo '_'];  % ' vs '
        FileName=[iddstring '/misc/mask/OutputMask_colorbar_' res '.png'];
        FileNameNCB=[iddstring '/misc/mask/OutputMask_nocolorbar_' res '.png'];
        FileNameOceans=[iddstring '/misc/mask/OutputMask_oceans_' res '.png'];
        FileNameAgriMask=[iddstring '/misc/mask/OutputMask_agrimask_' res '.png'];
        FileNamePT=[iddstring '/misc/mask/OutputMask_PT_' res '.png'];  % panoply triangles
        FileNamePTL=[iddstring '/misc/mask/OutputMask_PTL_' res '.png'];  % panoply triangles
        FileNamePTR=[iddstring '/misc/mask/OutputMask_PTR_' res '.png'];  % panoply triangles

        

% end

MaxNumFigs=callpersonalpreferences('maxnumfigsNSG');

if getnumionesurffigs > MaxNumFigs
    warndlg('too many figures currently open.')
    error('too many figures currently open.')
end
    
% Figure that is white everywhere
NSS.cmap=0*ones(size(colormap));


NSG(ii,NSS)
fud=get(gcf,'userdata')
set(fud.ColorbarHandle,'XTick',[]);
OutputFig('Force',FileName,NSS.Resolution);
close

NSG(ii,NSS)
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
NSG(ii,'cmap',NSS.cmap*0,'resolution',NSS.Resolution,'panoplytriangles',[1 1])
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


NSG(1-ii,NSS,'lowercolor','black')
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

NSG(k,NSS,'lowercolor','black','uppercolor','black')
fud=get(gcf,'userdata')

set(fud.ColorbarHandle,'Visible','off')
set(fud.ColorbarHandle,'XTick',[]);

OutputFig('Force',FileNameAgriMask,NSS.Resolution);
close