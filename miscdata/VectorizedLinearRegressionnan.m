function [x0,x1,Rsq,p,sig,SSE,linfit]=VectorizedLinearRegression(t,flatarray);
% VectorizedLinearRegression - vectorized linear regression
%
% SYNTAX
%          [x0,x1,Rsq,p,sig,SSE,linfit]=VectorizedLinearRegression(flatarray);
%          flatarray is an mxn array of points which represents n time
%          series 
%          x0  a 1xn vector of intercepts
%          x1  a 1xn vector of slopes
%          Rsq a 1xn vector of Rsquared values
%          p   a 1xn vector of p values
%          sig   1xn vector 0 if not significant, 1 if p<0.05
%          SSE   1xn vector of sum of squared error
%          linfit  mxn array with the linear fits 
%
%
%     Example:
%
% Nt=70
% flatarray=rand(Nt,100);
% for j=1:100;
%     flatarray(:,j)=flatarray(:,j)+linspace(0,j/50,Nt).';
% end
% 
% flatarray(10,:)=nan;
%
% [x0,x1,Rsq,p]=VectorizedLinearRegressionnan(flatarray);
% %now regress each one for comparison
% 
% for j=1:10;
%     Y=flatarray(:,j);
%     X=[ones(size(Y)) (1:numel(Y)).'];
%     [b,bint,r,rint,stats] = regress(Y,X);
%     x0a(j)=b(1);
%     x1a(j)=b(2);
%     Rsqa(j)=stats(1);
%     pa(j)=stats(3);
% end
% 
% figure
% subplot(221),plot(1:10,x0(1:10),1:10,x0a(1:10),'o')
% subplot(222),plot(1:10,x1(1:10),1:10,x1a(1:10),'o')
% subplot(223),plot(1:10,Rsq(1:10),1:10,Rsqa(1:10),'o')
% subplot(224),plot(1:10,p(1:10),1:10,pa(1:10),'o')



if nargin==1
    flatarray=t;
    t=1:size(flatarray,1);
end



whichtest='tstatistic';

switch whichtest
    case 'bootstrap'
        
        for j=1:Nbootstraps
            ii=randi(15,1,15);
            tj=t(ii);
            flatarrayj=flatarray(ii,:);
            
            % need linear regression here.
        
        
        
        end
    case 'tstatistic'
        
        % find the lines
        da=detrend_nan(flatarray);  % da is now the detrended version of the array
        Y=flatarray-da;   % Y is an array of the best-fit lines
        
        
        % now using notation of SanterEtAl, JGR2000
        b=(Y(end,:)-Y(1,:))/(t(end)-t(1));  % array of slopes
        
        nt=size(flatarray,1);
      %  t=1:nt;
      %  tbar=mean(t);
        
        e=da;
        
        se=sqrt( (1/(nt-2).*nansum(e.^2) ));
        
      %  sb=se./sqrt( sum(( t-tbar).^2));
        
      %  tb=b./sb;
        
        x0=Y(1,:);
        x1=b;

        %  I need to finish this, so I'm using some of the code from within
        %  Matlab's regress.m function.
        %
        %
        % let's recover rmse squared, Estimator of error variance, using
        % Matlab's notation
        p=2; % rank
        nu=nt-p;  % num degreees of freedom
        s2=se.^2;
        % single element
       % RSS=norm(Y(:,1)-mean(flatarray(:,1),1))^2;
        
        % now vectorized
  %      RSS= sum((Y-repmat(mean(flatarray,1),nt,1) ).^2);
        RSS= nansum((Y-repmat(nanmean(flatarray,1),nt,1) ).^2);
        
        
        Fstatistic=RSS./(p-1)./s2;
        clear RSS
      %  disp(['determing probability']);
   %     tic
         p=fpvallocal(Fstatistic,(p-1)*ones(size(Fstatistic)),nu*ones(size(Fstatistic)));
   %     toc

        % now to get Rsq ...
        r=flatarray-Y;  % y - yhat
        normr=sqrt(nansum(r.^2,1));
                clear r

        SSE=normr.^2;
        clear normr
        
        % TSS - like RSS but replace yhat (Y) with y (flatarray)
        TSS= nansum((flatarray-repmat(nanmean(flatarray,1),nt,1) ).^2);

        
        Rsq=1-SSE./TSS;
        % lookup table.  let's get a range of values for F
        
     %   Flookupvals=linspace(min(Fstatistic),max(Fstatistic),10000);
        
     
     
     if nargout>=5
        sig=p<0.05;
     end
     
     if nargout>=7
         linfit=Y;
     end
     
  
        
end




function p = fpvallocal(x,df1,df2)
% local version - since there is a version in private
%FPVAL F distribution p-value function.
%   P = FPVAL(X,V1,V2) returns the upper tail of the F cumulative distribution
%   function with V1 and V2 degrees of freedom at the values in X.  If X is
%   the observed value of an F test statistic, then P is its p-value.
%
%   The size of P is the common size of the input arguments.  A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    
%
%   See also FCDF, FINV.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.6.

%   Copyright 2010 The MathWorks, Inc. 


if nargin < 3, 
    error(message('stats:fpval:TooFewInputs')); 
end

xunder = 1./max(0,x);
xunder(isnan(x)) = NaN;
p = fcdf(xunder,df2,df1);
