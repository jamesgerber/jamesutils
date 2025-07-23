function MixDualFigures(Fig1Map,Fig1Scale,Fig2Map,Fig2Scale,NewFileName);
% MixDualFigures - replace white with full transparency, non-white with 1/2
%
%  Example
%
%   WhiteToAlpha(OLDFILENAME,NEWFILENAME);
%

Fig1Map=fixextension(Fig1Map,'.png');
Fig2Map=fixextension(Fig2Map,'.png');
Fig1Scale=fixextension(Fig1Scale,'.png');
Fig2Scale=fixextension(Fig2Scale,'.png');
NewFileName=fixextension(NewFileName,'.png');

plotimage1=imread(Fig1Map);
scaleimage1=imread(Fig1Scale);

plotimage2=imread(Fig2Map);
scaleimage2=imread(Fig2Scale);


s1=1-double(scaleimage1(:,:,1))/255;
s2=1-double(scaleimage2(:,:,1))/255;

background=(s1>=0.01 | s2 >= 0.01);


c2=[255	153	18]/255;  %pasture
%c2=[176 53 28]/255;
c2=[184	134	11]/255;
c2=[0.3281    0.1875    0.0195];
c2=[175 141 195]/255;
c2=[255 127 0]/255;
%c2=[238	173	14]/255;   % dark goldenrod
c2=[160	82	45]/255;  % sienna
c1=[48	128	20]/255;  %cropland
c1=[34	139	34]/255;

%c1=[0.0049    0.2388    0.1919];
%c1=[27 191 123]/255;
%c1=[39 113 36]/255;
%c1=[246 113 255]/255;


%xxx=c2;
%c2=c1;
%c1=xxx;

%c2=[156	102	31]/255;
b=[255	246	143]/255;	% base
b=[250	250	210]/255; %
b=[1 1 1]*.5;


N=1/2;

% darker colors
  for ichan=1:3
 %   JointImage(:,:,ichan)=double(c1(ichan)).*(s1.^2./(s1.^2+s2.^2)) + ...
 %       double(c2(ichan)).*(s2.^2./(s1.^2+s2.^2));
  

% JointImage(:,:,ichan)=double(c1(ichan)).*(s1.^2) + ...
 %       double(c2(ichan)).*(s2.^2);
 
JointImage(:,:,ichan)=double(b(ichan).*background)+(double(c1(ichan)-b(ichan))).*(s1.^N) + ...
        double(c2(ichan)-b(ichan)).*(s2.^N);
     
    
  end
  
  
  Alpha=1-(s1<.01 & s2 < .01);
  
imwrite(JointImage,'tmp_alpha.png','png','Alpha',uint8(Alpha*255));
imwrite(JointImage,NewFileName);%,'png','Alpha',uint8(Alpha*255));


%% now make a legend
tic
legimage=double(plotimage1(1:120,1:120,:))*0+1;
AlphaChannel=legimage(:,:,1);
for j=0:100
    for k=0:(100-j)
        for ichan=1:3
            
            legimage(j+10,k+10,ichan)=double(b(ichan))+(double(c1(ichan)-b(ichan))).*(j/100).^N + ...
                double(c2(ichan)-b(ichan)).*(k/100).^N;
            
        end       
        AlphaChannel(j+10,k+10)=0;
    end
end
toc
imwrite(legimage,'legendimage.png');
imwrite(legimage,'legendimagewithalpha.png','png','Alpha',uint8((1-AlphaChannel)*255));


        