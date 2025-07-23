function maketransparentOcReg_noant_nogridlinesnostates_removeislands(OldFileName,NewFileName,TextColor,AgFlag,Region,printres,datares);
% maketransparentoceans_noant - add a transparent channel around landmass
%
%  Example
%   Syntax
%        maketransparentoceans_noant(OLDFILENAME,NEWFILENAME);
%
%        maketransparentoceans_noant(OLDFILENAME,NEWFILENAME,TEXTCOLOR);
%
%        maketransparentoceans_noant(OLDFILENAME,'',TEXTCOLOR);
%
%
%        maketransparentoceans_noant(OLDFILENAME,NEWFILENAME,TEXTCOLOR,AGFLAG);%
%
%        maketransparentoceans_noant(OLDFILENAME,TEXTCOLOR);
%    TEXTCOLOR is a three element vector
%
%
%   Example
%
%     m=getdata('maize');
%     y=m.Data(:,:,2);
%     nsg(y,'filename','test_mtb.png','title','maize yield','caxis',.98,...
%     'cmap','summer','units','tons/ha')
%
%     maketransparentoceans_noant('test_mtb','test_mto_alpha_white',[1 1 1])
%
%     maketransparentoceans_noant('test_mtb','test_mto_alpha_umnmaroon',umnmaroon)
%
%     maketransparentoceans_noant('test_mtb','test_mto_alpha_agrimask_umnmaroon',umnmaroon,1)
%
%     m=getdata('maize');
%     y=m.Data(:,:,2);
%     nsg(y,'filename','test_mtb2.png','title','maize yield','caxis',.98,...
%     'cmap','summer','units','tons/ha','sink','nonagplaces','states','agplaces')
% 
%     maketransparentoceans_noant('test_mtb2','test_mtb2_alpha_white',[1 1 1],1)
%
%    see also maketransparencymasks maketransparentbackground maketransparentoceans

if nargin<4
    AgFlag=0;
end

if nargin==1
    NewFileName=strrep(OldFileName,'.png','_alpha_to_na_nogridnostates.png');
end


if isempty(NewFileName)
     [WithExtension,WithoutExtension]=fixextension(OldFileName,'.png');
    NewFileName=strrep(WithExtension,'.png','_alpha_to_na_nogridnostates.png');
end


OldFileName=fixextension(OldFileName,'.png');

plotimage=imread(OldFileName);

KeepText=0;
if ~ischar(NewFileName)
    TextColor=NewFileName;
    NewFileName=strrep(OldFileName,'.png','_alpha_to_na_nogridnostates');
    NewFileName=[makesafestring(NewFileName) '.png']
    NewFileName=fixextension(NewFileName,'.png');
    KeepText=1;
end

if nargin==1 | isempty(NewFileName)
    NewFileName=strrep(OldFileName,'.png','_alpha_to_na_nogridnostates');
    NewFileName=fixextension(NewFileName,'.png');
    %   NewFileName=[makesafestring(NewFileName) '.png']
else
    NewFileName=fixextension(NewFileName,'.png');
end



if nargin>=3
    KeepText=1;
end


ver=version;
VerNo=ver(1)
vs=['ver' VerNo '_'];  % ' vs '



a=plotimage;

approxdpi2010=1200*size(a,1)/5066;
approxdpi2012=1200*size(a,1)/6334;


printres=['size' num2str(size(a,1)) '_' num2str(size(a,2))];


% FileName=[iddstring '/misc/mask/OutputMask_colorbar_' res 'nogridnostates.png'];
% FileNameNCB=[iddstring '/misc/mask/OutputMask_nocolorbar_' res 'nogridnostates.png'];
% FileNameOceans=[iddstring '/misc/mask/OutputMask_oceans_' res 'nogridnostates.png'];
% FileNameAgriMask=[iddstring '/misc/mask/OutputMask_agrimask_' res 'nogridnostates.png'];
% FileNamePT=[iddstring '/misc/mask/OutputMask_PT_' res 'nogridnostates.png'];


FileName=[iddstring '/misc/masknewgen/OutputMask_colorbar_' Region '_' datares '_' printres 'nogridnostates.png'];
FileNameWithStates=[iddstring '/misc/masknewgen/OutputMask_colorbarWithStateLines_' Region '_' datares '_' printres 'nogridnostates.png'];
FileNameNCB=[iddstring '/misc/masknewgen/OutputMask_nocolorbar_'  Region '_' datares  '_' printres 'nogridnostates.png'];
FileNameOceans=[iddstring '/misc/masknewgen/OutputMask_oceans_'  Region '_' datares  '_' printres 'nogridnostates.png'];
FileNameAgriMask=[iddstring '/misc/masknewgen/OutputMask_agrimask_'  Region '_' datares  '_' printres 'nogridnostates.png'];
FileNamePT=[iddstring '/misc/masknewgen/OutputMask_PT_'  Region '_' datares  '_' printres 'nogridnostates.png'];  % panoply triangles
FileNamePTL=[iddstring '/misc/masknewgen/OutputMask_PTL_'  Region '_' datares  '_' printres 'nogridnostates.png'];  % panoply triangles
FileNamePTR=[iddstring '/misc/masknewgen/OutputMask_PTR_'  Region '_' datares  '_' printres 'nogridnostates.png'];  % panoply triangles



try
    a=imread(FileName);
    aws=imread(FileNameWithStates);
    ancb=imread(FileNameNCB);
    aocean=imread(FileNameOceans);
    aagrimask=imread(FileNameAgriMask);
    apt=imread(FileNamePT);
catch
    warning([' did not find one or more of the masks!!'])
    disp([' you probably need to run maketransparencymasks_nogridlinesnostates_Regional.m '])
    disp([' The resolution seems to be '  int2str(approxdpi2010)])
        disp([' or '  int2str(approxdpi2012)])
    disp([' Note, however, that due to some matlab quirks, there are different '])
    disp([' masks made for according to monitor size and matlab version '])
    disp([' and most annoyingly, resolution at which you have the monitor '])
    disp(['% example maketransparencymasks_nogridlinesnostates_Regional(''r600'',''SEAsia'',''5min'');'])

    error(lasterr)
end
% 
% figure,surface(aws(:,:,1)),shading flat
% figure,surface(aws(:,:,2)),shading flat
% figure,surface(aws(:,:,3)),shading flat
% figure,surface(a(:,:,1)),shading flat
% figure,surface(a(:,:,2)),shading flat
% figure,surface(a(:,:,3)),shading flat
% 

ii_states_outsideROI=~( aws(:,:,1)==255 & aws(:,:,2) ==255 & aws(:,:,3)==255) ...
    & (( a(:,:,1)==255 & a(:,:,2) ==255 & a(:,:,3)==255));

%tmp=( a(:,:,1)==255 & a(:,:,2) ==255 & a(:,:,3)==255) ;

ii_background=(ancb(:,:,1)==255 & ancb(:,:,2) ==255 & ancb(:,:,3)==255);
ii_foreground=~ii_background;

b=plotimage;
ii_colorbar= ~((a(:,:,1) ~=ancb(:,:,1)) | (a(:,:,2) ~=ancb(:,:,2)) | (a(:,:,3) ~=ancb(:,:,3)));
ii_text= ((a(:,:,1) ~=b(:,:,1)) | (a(:,:,2) ~=b(:,:,2)) | (a(:,:,3) ~=b(:,:,3)))  ...
    & ~ii_foreground & ii_colorbar;

ii_triangles=((a(:,:,1) ~=apt(:,:,1)) | (a(:,:,2) ~=apt(:,:,2)) | (a(:,:,3) ~=apt(:,:,3)));
%ii_trianglesl=((a(:,:,1) ~=aptl(:,:,1)) | (a(:,:,2) ~=aptl(:,:,2)) | (a(:,:,3) ~=aptl(:,:,3)));
%ii_trianglesr=((a(:,:,1) ~=aptr(:,:,1)) | (a(:,:,2) ~=aptl(:,:,2)) | (a(:,:,3) ~=aptr(:,:,3)));


ii_text_notriangles=ii_text &~ii_triangles;

%
ii_keep_triangles=ii_text & ii_triangles;

ii_colorbar=ii_colorbar & ~ii_keep_triangles;


% there might not be a colorbar ... check. 
colorbarpoints=find(ii_colorbar==0);

% let's look in a
for j=1:3
    x=b(:,:,j);
    smallbit(:,:,j)=x(colorbarpoints);
    modalcolors(j)=mode(x(colorbarpoints));
    meancolors(j)=mean(x(colorbarpoints));
end

if numel(unique(meancolors))==1
    'no colorbar'

    ii_colorbar=logical(ones(size(ii_colorbar)));

else
    'colorbar'
end
    




ii_ocean=(aocean(:,:,1)==255 & aocean(:,:,2) ==255 & aocean(:,:,3)==255);

ii_ag=(aagrimask(:,:,1)==255 & aagrimask(:,:,2) ==255 & aagrimask(:,:,3)==255);

% what should we keep?

% to do:  pull two loops below together by making ii_ag = field of ones
%         remove somewhat embarassing FlipToZero

if AgFlag==0
    
    if KeepText==0;
        Alpha=(~ii_background | ~ii_colorbar )& ii_ocean ;
        FlipToZero=(Alpha==1 & ii_ag==0);
        Alpha(FlipToZero)=0;
        
        finalwrite(plotimage,NewFileName,'png','Alpha',uint8(Alpha*255));
    else
        Alpha=(~ii_background | ~ii_colorbar )& ii_ocean ; ;
        Alpha(ii_keep_triangles)=1;
      %  Alpha(ii_colorbar)=1;
              Alpha(ii_text)=1;

              ii_crap=sum(aagrimask,3)==0 & sum(aocean,3)>100;
          
              
              
              
              
        x=plotimage(:,:,1); x(ii_text_notriangles)=TextColor(1)*255; plotimage(:,:,1)=x;
        x=plotimage(:,:,2); x(ii_text_notriangles)=TextColor(2)*255; plotimage(:,:,2)=x;
        x=plotimage(:,:,3); x(ii_text_notriangles)=TextColor(3)*255; plotimage(:,:,3)=x;
        
         Alpha(ii_crap)=0;
         
         finalwrite(plotimage,NewFileName,'png','Alpha',uint8(Alpha*255));

%         x=plotimage(:,:,1); x(ii_crap)=TextColor(1)*255; plotimage(:,:,1)=x;
%         x=plotimage(:,:,2); x(ii_text_notriangles)=TextColor(2)*255; plotimage(:,:,2)=x;
%         x=plotimage(:,:,3); x(ii_text_notriangles)=TextColor(3)*255; plotimage(:,:,3)=x;

        
        
    end
    
else
    
    if KeepText==0;
        Alpha=(~ii_background | ~ii_colorbar )& ii_ocean ;
        FlipToZero=(Alpha==1 & ii_ag==0);
        Alpha(FlipToZero)=0;
        finalwrite(plotimage,NewFileName,'png','Alpha',uint8(Alpha*255));
    else
        Alpha=(~ii_background | ~ii_colorbar | ~ii_states_outsideROI )& ii_ocean ;
        Alpha=(~ii_background | ~ii_colorbar  )& ii_ocean ;
        FlipToZero=(Alpha==1 & ii_ag==0);
        Alpha(FlipToZero)=0;
        
        Alpha(ii_text)=1;
        x=plotimage(:,:,1); x(ii_text_notriangles)=TextColor(1)*255; plotimage(:,:,1)=x;
        x=plotimage(:,:,2); x(ii_text_notriangles)=TextColor(2)*255; plotimage(:,:,2)=x;
        x=plotimage(:,:,3); x(ii_text_notriangles)=TextColor(3)*255; plotimage(:,:,3)=x;
        finalwrite(plotimage,NewFileName,'png','Alpha',uint8(Alpha*255));
    end
end

return

function finalwrite(plotimage,NewFileName,type,alphaname,Alphavar);

y1=.68;
y2=.78;

N=size(Alphavar,1);

m1=floor(y1.*N);
m2=ceil(y2.*N);

ii=[1:m1 m2:N];

imwrite(plotimage(ii,:,:),NewFileName,type,alphaname,Alphavar(ii,:));

