function mergewhitewithoutline(OldFileName1,OldFileName2,NewFileName)

OldFileName1=fixextension(OldFileName1,'.png');
plotimage1=imread(OldFileName1);

OldFileName2=fixextension(OldFileName2,'.png');
plotimage2=imread(OldFileName2);

NewFileName=fixextension(NewFileName,'.png');

a=plotimage1;
ii1=(a(:,:,1)>=254 & a(:,:,2) >=254 & a(:,:,3)>=254);

a=plotimage2;
ii2=(a(:,:,1)>=254 & a(:,:,2) >=254 & a(:,:,3)>=254);

% four cases

% not in either plot - make fully transparent
FullTrans=(~ii1 & ~ii2);

% in both plots - average
BothPlots=(ii1 & ii2);

% in ii1, not in ii2
FirstPlot=ii1&~ii2;
SecondPlot=ii2&~ii1;


plotimage1=double(plotimage1);
plotimage2=double(plotimage2);

% start with averaging the two images
newimage=(plotimage1 + plotimage2)/2;

% for points in ii1 & not ii2, assign to value in ii1
% 
% indexvect=find(ii1);
% for j=1:3;
%     plotimage1layer=plotimage1(:,:,j);
%     plotimage2layer=plotimage2(:,:,j);
%     newimagelayer=newimage(:,:,j);
%     
%     newimagelayer(FirstPlot)=plotimage1layer(FirstPlot);
%     newimagelayer(SecondPlot)=plotimage2layer(SecondPlot);
% 
%     newimage(:,:,j)=newimagelayer;
% end

%newimage=plotimage1;

Alpha=FullTrans;

imwrite(uint8(newimage),NewFileName,'png')%,'Alpha',uint8(FullTrans));%,'Background',ones(size(Alpha)));