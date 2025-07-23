function [T,eta,phi]=BestAiryFit(t,x,T0,eta0,xmean)
% BESTAIRYFIT - determine parameters of a sine wave which most closely matches data
%
%  This can be extremely useful for determinining a relatively small set of 
% sinusoids which can model an irregular wave train.  Find the best fit (using 
% this code) then store that sin wave, subtract it from the data set, and all 
% again.  This is an effective (although brute-force) way to determine the 
% spectral content of a signal with only a few components.
%
%  SYNTAX
%
%   [Tbest,eta_best,Phi_best]=BestAiryFit(t,x,T0_guess,eta0_guess,xmean_guess)
%
%  EXAMPLE
%   t=0:10
%   x=sin(t)+rand(1,11)
%   [Tbest,eta_best,Phi_best]=BestAiryFit(t,x,.2,0.0,.4)
if nargin==0
    help(mfilename);
    return
end

if nargin==2
    T0=1;
    eta0=(max(x)-min(x))/2;
    xmean=(max(x)-min(x))/2;
end

if nargin==3
    eta0=(max(x)-min(x))/2;
    xmean=(max(x)-min(x))/2;
end

x=x(:);


options=optimset;
options.TolFun=1e-6;
x0=[T0 eta0 0 xmean];
[tep1,fval1]=fminsearch('AiryError',x0,options,t,x);

x0=[T0 eta0 pi/2 xmean];
[tep2,fval2]=fminsearch('AiryError',x0,options,t,x);


x0=[T0 eta0 pi xmean];
[tep3,fval3]=fminsearch('AiryError',x0,options,t,x);


x0=[T0 eta0 -pi/2 xmean];
[tep4,fval4]=fminsearch('AiryError',x0,options,t,x);


[dum,ii]=min([fval1 fval2 fval3 fval4]);

%disp(['tep=tep' num2str(ii)]);

eval(['tep=tep' num2str(ii) ';']);


T=tep(1);
eta=tep(2);
phi=tep(3);


