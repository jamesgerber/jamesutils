function [ContourMask,CutoffValue,NumContours,RecLevel,CS,Areas]=...
    FindCompactSmoothContourRevP(Dist,p,Lsmooth,kx,ky,MaxNumCont,ExcludeMask,RecLevel)
%FindCompactSmoothContourRevP - find smooth contours containing a certain fraction of a distribution
%
%   Revision P version - used to make Revision P.
%
%   Syntax:
%       [ContourMask,CutoffValue,NumContours]=FindCompactSmoothContourRevP(Dist
%       ,p,Lsmooth,Xweight,Yweight,MaxNumContours,ExcludeMask)
%
%   Dist        - distribution
%   p           - percentile to include
%   kx          - filter normalization for x dimension (see example)
%   ky          - filter normalization for y dimension
%   MaxNumCont  - Max number of contours
%   ExcludeMask - Mask of Dist to exclude 
%
%
%   This works by taking a convolution product of distribution DIST with a
%   filter F defined as F=exp(-x.^2.*kx.^2)*exp(-y.^2.*ky.^2)  then finding
%   a contour so that p% is contained inside.   If the number of contours
%   is greater than MAXNUMCONT, the part of the distribution inside the
%   smallest one is excluded from further analysis.
%
%
%  Example
%
%     % load in a crop / find data quality production
%     C=getdata('maize');
%     Lat=C.Lat;
%     Long=C.Long;     
%     [Lat2d,Long2d]=meshgrid(Lat,Long);
%
%     kkDQ=(LandMaskLogical & C.Data(:,:,1) >0 & C.Data(:,:,1) < 9e9 ...
%         & C.Data(:,:,2) >0 & C.Data(:,:,2) < 9e9);
%     Production=C.Data(:,:,1).*C.Data(:,:,2).*GetFiveMinGridCellAreas;
%     kkDQ=(kkDQ & isfinite(Production));
%     Production(~kkDQ)=0;
%     
%     %US grain belt
%     ii=find(Long >= -130 & Long <= -60); 
%     jj=find( Lat >= 10 &  Lat <= 60);
%     
%     X=Long2d(ii,jj);
%     Y=Lat2d(ii,jj);
%     Z=double(Production(ii,jj));
%
%     L=100 % km ... smoothing length
%     Xlong=Long2d(:,1);
%     Ylat=Lat2d(1,:);
%
%     Xkm=Xlat.*(40000/360);   %long to km
%     Ykm=Ylong.*(40000/360);   %lat to km
%
%     kx=1./(Xkm.^2)
%     ky=1./(Ykm.^2)
%    Lsmooth_normunits=Lsmooth*(360/40000)*(12);

      
 %   [Belt,CutoffValue]=FindContourGen(Z,Zblob,BeltPercentile,MaxBlobNumber);
    
%    function [ContourMask,CutoffValue,NumContours]=FindCompactSmoothContourRevP(Dist,p,kx,ky,MaxNumCont,ExcludeMask)
%%%[Belt,CutoffValue,NumContours]=FindCompactSmoothContourRevP(Z,BeltPercentile,Lsmooth_normunits,1,1,MaxBlobNumber)

%

if p==1
    ContourMask=logical(ones(size(Dist)));
    CutoffValue=min(min(Dist));
    NumContours=1;
    return
end

if nargin< 7
    ExcludeMask =logical(zeros(size(Dist)));
end

if nargin < 8
    RecLevel=0;
end

RecLevel

%%  Construct a filter
[nx,ny]=size(Dist);

x=1:nx;
y=1:ny;

x=x-mean(x);
y=y-mean(y);

x=x(:)';  %x is row
y=y(:);   %y is column
kx=kx(:)';
ky=ky(:);

fx=exp(-x.^2.*kx.^2./Lsmooth.^2);
fy=exp(-y.^2.*ky.^2./Lsmooth.^2);

ii=(fx>max(fx)/1e6);
jj=(fy>max(fy)/1e6);

filt=(fy(jj)*fx(ii))'; %need to transpose so I can continue with my not-matlab-standard interp of row/col


%% Where ExcludeMask is 1, set Dist to zero.
DistTemp=Dist;
DistTemp(ExcludeMask)=0;

%% perform smoothing
tic
DistSmooth=conv2(DistTemp,filt,'same');
toc

%% Now have a smoothed distribution.  Find a contour.
    
DistSmooth_norm=DistSmooth/max(max(DistSmooth));

level=fzero(@(level) testlevel(level,Dist,DistSmooth_norm,p,ExcludeMask),.1);

ContourMask=(DistSmooth_norm>level);
debugplot=0;
if debugplot
    figure;
    subplot(2,2,1);surface(double(ExcludeMask));shading flat;title('exclude mask');
    subplot(2,2,2);surface(double(DistTemp));shading flat;title('DistTemp');
    subplot(2,2,3);surface(double(DistSmooth_norm));shading flat;title('DistSmooth_norm');
    subplot(2,2,4);surface(double(ContourMask));shading flat;title('ContourMask');
end

%if length(unique(ExcludeMask))==2
%    %  jj=find(ExcludeMask);
%    %  ContourMask(ExcludeMask)=ContourMask(jj(end)+1);
%    ContourMask(ExcludeMask)=~ContourMask(ExcludeMask);
%end

CutoffValue=level*max(max(Dist));  %need to renormalize

%% how many contours?
a=zeros(302,302);
a(2:301,2:301)=ContourMask;
C=contourc(double(a),[.5 .5]);
%C=contourc(double(ContourMask),[.5 .5]);
CS=parse_contourc_output(C)
NumContours=length(CS);
if NumContours > MaxNumCont
    
  
    
    
    %    jpmax=jpmax.*(~ii);
    
   % [ContourMask,CutoffValue]=FindContourGen(jp,jpmax,p,MaxNumContours,ExcludeMask);
   if RecLevel < 25
       ExcludeMask =logical(zeros(size(Dist)));

    [ContourMask,CutoffValue,NumContours,RecLevel_dummy,CS]=...
        FindCompactSmoothContourRevP(Dist,p,Lsmooth*1.1,kx,ky,MaxNumCont,ExcludeMask,RecLevel+1);
   else
       disp(['Not going any deeper in recursion'])
       keyboard
       %% we are going home ... we have given up.  Now we should return the details.
       
       
       
   end
    return
end





function tlerror=testlevel(level,jp,jpmax,p,ExcludeMask)
% returns an error measure of how far off level is from giving
% contour that encloses p percent of jp

%if length(unique(ExcludeMask))==1
%    ii=(jpmax>level);
%    pguess=sum(jp(ii))/sum(sum(jp));
%    tlerror=(pguess-p);
%else
    ii=(jpmax>level);% & ExcludeMask==0);
    pguess=sum(jp(ii))/sum(sum(jp));
    tlerror=(pguess-p);
%end


