function maketransparentoceans(OldFileName,NewFileName,TextColor,AgFlag);
% maketransparentoceans - add a transparent channel around landmass
%
%  Example
%   Syntax
%        maketransparentoceans(OLDFILENAME,NEWFILENAME);
%
%        maketransparentoceans(OLDFILENAME,NEWFILENAME,TEXTCOLOR);
%
%        maketransparentoceans(OLDFILENAME,'',TEXTCOLOR);
%
%        maketransparentoceans(OLDFILENAME,NEWFILENAME,TEXTCOLOR,AGFLAG);%
%
%        maketransparentoceans(OLDFILENAME,TEXTCOLOR);
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
%     maketransparentoceans('test_mtb','test_mto_alpha_white',[1 1 1])
%
%     maketransparentoceans('test_mtb','test_mto_alpha_umnmaroon',umnmaroon)
%
%     maketransparentoceans('test_mtb','test_mto_alpha_agrimask_umnmaroon',umnmaroon,1)
%
%    see also maketransparencymasks maketransparentbackground maketransparentoceans

if nargin<4
    AgFlag=0;
end

if nargin==1
    NewFileName=strrep(OldFileName,'.png','_alpha.png');
end

if isempty(NewFileName)
    [WithExtension,WithoutExtension]=fixextension(OldFileName,'.png');
    NewFileName=strrep(WithExtension,'.png','_alpha.png');
end

OldFileName=fixextension(OldFileName,'.png');

plotimage=imread(OldFileName);

KeepText=0;
if ~ischar(NewFileName)
    TextColor=NewFileName;
    NewFileName=strrep(OldFileName,'.png','_alpha_to');
    NewFileName=[makesafestring(NewFileName) '.png']
    NewFileName=fixextension(NewFileName,'.png');
    KeepText=1;
end

if nargin==1 | isempty(NewFileName)
    NewFileName=strrep(OldFileName,'.png','_alpha_to');
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

res=['size' num2str(size(a,1)) '_' num2str(size(a,2))];


FileName=[iddstring '/misc/mask/OutputMask_colorbar_' res '.png'];
FileNameNCB=[iddstring '/misc/mask/OutputMask_nocolorbar_' res '.png'];
FileNameOceans=[iddstring '/misc/mask/OutputMask_oceans_' res '.png'];
FileNameAgriMask=[iddstring '/misc/mask/OutputMask_agrimask_' res '.png'];
FileNamePT=[iddstring '/misc/mask/OutputMask_PT_' res '.png'];

a=imread(FileName);
ancb=imread(FileNameNCB);
aocean=imread(FileNameOceans);
aagrimask=imread(FileNameAgriMask);
apt=imread(FileNamePT);







ii_background=(ancb(:,:,1)==255 & ancb(:,:,2) ==255 & ancb(:,:,3)==255);
ii_foreground=~ii_background;

b=plotimage;
ii_colorbar= ~((a(:,:,1) ~=ancb(:,:,1)) | (a(:,:,2) ~=ancb(:,:,2)) | (a(:,:,3) ~=ancb(:,:,3)));
ii_text= ((a(:,:,1) ~=b(:,:,1)) | (a(:,:,2) ~=b(:,:,2)) | (a(:,:,3) ~=b(:,:,3)))  ...
    & ~ii_foreground & ii_colorbar;

ii_triangles=((a(:,:,1) ~=apt(:,:,1)) | (a(:,:,2) ~=apt(:,:,2)) | (a(:,:,3) ~=apt(:,:,3)));
%ii_trianglesl=((a(:,:,1) ~=aptl(:,:,1)) | (a(:,:,2) ~=aptl(:,:,2)) | (a(:,:,3) ~=aptl(:,:,3)));
%ii_trianglesr=((a(:,:,1) ~=aptr(:,:,1)) | (a(:,:,2) ~=aptl(:,:,2)) | (a(:,:,3) ~=aptr(:,:,3)));

%
ii_keep_triangles=ii_text & ii_triangles;
ii_text_notriangles=ii_text &~ii_triangles;

ii_colorbar=ii_colorbar & ~ii_keep_triangles;


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
        
        imwrite(plotimage,NewFileName,'png','Alpha',uint8(Alpha*255));
    else
        Alpha=(~ii_background | ~ii_colorbar )& ii_ocean ; ;
        Alpha(ii_text)=1;
        x=plotimage(:,:,1); x(ii_text_notriangles)=TextColor(1)*255; plotimage(:,:,1)=x;
        x=plotimage(:,:,2); x(ii_text_notriangles)=TextColor(2)*255; plotimage(:,:,2)=x;
        x=plotimage(:,:,3); x(ii_text_notriangles)=TextColor(3)*255; plotimage(:,:,3)=x;
        imwrite(plotimage,NewFileName,'png','Alpha',uint8(Alpha*255));
    end
    
else
    
    if KeepText==0;
        Alpha=(~ii_background | ~ii_colorbar )& ii_ocean ;
        FlipToZero=(Alpha==1 & ii_ag==0);
        Alpha(FlipToZero)=0;
        imwrite(plotimage,NewFileName,'png','Alpha',uint8(Alpha*255));
    else
        Alpha=(~ii_background | ~ii_colorbar )& ii_ocean ;
        FlipToZero=(Alpha==1 & ii_ag==0);
        Alpha(FlipToZero)=0;
        
        Alpha(ii_text)=1;
        x=plotimage(:,:,1); x(ii_text)=TextColor(1)*255; plotimage(:,:,1)=x;
        x=plotimage(:,:,2); x(ii_text)=TextColor(2)*255; plotimage(:,:,2)=x;
        x=plotimage(:,:,3); x(ii_text)=TextColor(3)*255; plotimage(:,:,3)=x;
        imwrite(plotimage,NewFileName,'png','Alpha',uint8(Alpha*255));
    end
end

