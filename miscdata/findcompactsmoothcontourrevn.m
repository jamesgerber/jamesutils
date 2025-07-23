function [ContourMask,CutoffValue,NumContours,RecLevel,CS,Areas]=...
    FindCompactSmoothContourRevN(Dist,p,Lsmooth,kx,ky,MaxNumCont,ExcludeMask,RecLevel)
%FindCompactSmoothContourRevN - find smooth contours containing a certain fraction of a distribution
%
%   Revision N version - this was used to make Revision N.  However, it
%   doesn't always work ... it turns out that there are some cases where it
%   can't find a simple contour when it probably should.
%
%   Syntax:
%       [ContourMask,CutoffValue,NumContours]=FindCompactSmoothContourRevN(Dist
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
    
%    function [ContourMask,CutoffValue,NumContours]=FindCompactSmoothContourRevN(Dist,p,kx,ky,MaxNumCont,ExcludeMask)
%%%[Belt,CutoffValue,NumContours]=FindCompactSmoothContourRevN(Z,BeltPercentile,Lsmooth_normunits,1,1,MaxBlobNumber)

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
debugplot=1;
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

C=contourc(double(ContourMask),[.5 .5]);
CS=parse_contourc_output(C)
NumContours=length(CS);
if NumContours > MaxNumCont
    
    % too many contours.  kill the smallest one and call self again
    % recursively.  We kill the smallest one by zeroing out jpmax.
    
    for j=1:length(CS)
        av(j)=polyarea(CS(j).X,CS(j).Y);
    end
    
    
    
    
    
    
    
    [dum,polygonlist]=sort(av);
    k=polygonlist(1);
    %     % first need to make sure that don't have nested polygons
    %     for j=2:length(polygonlist)
    %         k=polygonlist(j);
    %         NestCheck(j)=length(find(inpolygon(CS(j).X,CS(j).Y,CS(k).X,CS(k).Y)))>0
    %
    %     end
    %
    %     if any(NestCheck(j))
    %         error(['found a nested polygon.  trying the next one!!'])
    %        % [dum,iinextbest]=min(NestCheck);  %think this will work.
    %        % k=polygonlist(iinextbest+1);
    %     end
    
    
    [nx,ny]=size(ContourMask);
    [X,Y]=meshgrid(1:ny,1:nx);
    tic
    [ii]=inpolygon(X,Y,CS(k).X,CS(k).Y);
    disp('time in inpolygon')
    toc
    
    
    OldExcludeMask=ExcludeMask;
    ExcludeMask= ExcludeMask | ii;

    if isequal(OldExcludeMask,ExcludeMask);
       
    % here is a bit to catch a special case where the old exclude mask is
    % the same as the new exclude mask.  There can be a small little bit
    % which doesn't get smoothed away.  If this happens, make a somewhat
    % more Excluding ExcludeMask.  make the shape bigger ... so that it is
    % approx Lsmooth/10  x Lsmooth / 10.  [normalize by variance of x,y]
     
        xt=CS(k).X;
        yt=CS(k).Y;
        
        xt0=xt-mean(xt);
        yt0=yt-mean(yt);

        xtnew=mean(xt)+(xt0)/var(xt0)*(Lsmooth/5);
        ytnew=mean(yt)+(yt0)/var(yt0)*(Lsmooth/5);
        
        
        ii1=inpolygon(X,Y,xtnew,ytnew);
        ExcludeMask= ExcludeMask | ii1 ;

    end
    
    
    
    %    jpmax=jpmax.*(~ii);
    
   % [ContourMask,CutoffValue]=FindContourGen(jp,jpmax,p,MaxNumContours,ExcludeMask);
   if RecLevel < 15
    [ContourMask,CutoffValue,NumContours,RecLevel_dummy,CS]=...
        FindCompactSmoothContourRevN(Dist,p,Lsmooth,kx,ky,MaxNumCont,ExcludeMask,RecLevel+1);
   else
       disp(['Not going any deeper in recursion'])
       
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


