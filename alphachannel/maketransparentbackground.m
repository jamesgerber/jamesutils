function S=maketransparentbackground(OldFileName,NewFileName,TextColor);
% maketransparentbackground - add a transparent channel around a figure
%
%  Example
%   Syntax
%        maketransparentbackground(OLDFILENAME,NEWFILENAME);
%
%        maketransparentbackground(OLDFILENAME,NEWFILENAME,TEXTCOLOR);
%
%        maketransparentbackground(OLDFILENAME,TEXTCOLOR);
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
%     maketransparentbackground('test_mtb','test_mtb_alpha',[.4 .4 .5])
%
%     maketransparentbackground('test_mtb','test_mtb_alpha',umnmaroon)
%
%    see also maketransparencymasks

OldFileName=fixextension(OldFileName,'.png');

plotimage=imread(OldFileName);

KeepText=0;

if nargin==1
    NewFileName=strrep(OldFileName,'.png','_alpha_tb.png');
    TextColor=[1 1 1]; % jg added this line Jan 2017
    KeepText=1;
end




ver=version;
VerNo=ver(1)
vs=['ver' VerNo '_'];  % ' vs '


if ~ischar(NewFileName)
    TextColor=NewFileName;
    NewFileName=strrep(OldFileName,'.png','_alpha_tb');
    NewFileName=[makesafestring(NewFileName) '.png']
    NewFileName=fixextension(NewFileName,'.png');
    KeepText=1;
end

if nargin==1
    NewFileName=strrep(OldFileName,'.png','_alpha_tb');
    NewFileName=[makesafestring(NewFileName) '.png']
else
    NewFileName=fixextension(NewFileName,'.png');
end



if nargin>=3
    KeepText=1;
end

a=plotimage;

res=['size' num2str(size(a,1)) '_' num2str(size(a,2))];


FileName=[iddstring '/misc/mask/OutputMask_colorbar_' res '.png'];
FileNameNCB=[iddstring '/misc/mask/OutputMask_nocolorbar_' res '.png'];
FileNameOceans=[iddstring '/misc/mask/OutputMask_oceans_' res '.png'];
FileNameAgriMask=[iddstring '/misc/mask/OutputMask_agrimask_' res '.png'];
FileNamePT=[iddstring '/misc/mask/OutputMask_PT_' res '.png'];
%FileNamePTL=[iddstring '/misc/mask/OutputMask_PTL_' res '.png'];
%FileNamePTR=[iddstring '/misc/mask/OutputMask_PTR_' res '.png'];

a=imread(FileName);
ancb=imread(FileNameNCB);
apt=imread(FileNamePT);
%aptl=imread(FileNamePTL);
%aptr=imread(FileNamePTR);
%aocean=imread(FileNameOceans);
%aagrimask=imread(FileNameAgriMask);


%a=apt;   % i think this is all we need to do ... to include panoply triangles




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
% what should we keep?



if KeepText==0;
    Alpha=~ii_background | ~ii_colorbar;
    imwrite(plotimage,NewFileName,'png','Alpha',uint8(Alpha*255));
else
    Alpha=(~ii_background | ~ii_colorbar ) ;
    Alpha(ii_text)=1;
    x=plotimage(:,:,1); x(ii_text_notriangles)=TextColor(1)*255; plotimage(:,:,1)=x;
    x=plotimage(:,:,2); x(ii_text_notriangles)=TextColor(2)*255; plotimage(:,:,2)=x;
    x=plotimage(:,:,3); x(ii_text_notriangles)=TextColor(3)*255; plotimage(:,:,3)=x;
    imwrite(plotimage,NewFileName,'png','Alpha',uint8(Alpha*255));
end

S.OutputMask=a;
S.OutputMask_nocolorbar=ancb;
S.OutputMask_pt=apt;
S.plotimage=plotimage;
S.background=ii_background;
S.Alpha=Alpha;
