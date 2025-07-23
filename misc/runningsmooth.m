function s=runningsmooth(t,y,T,LEGACY);
% RUNNINGSMOOTH - Clumsy (but convenient) boxcar smoothing algorihm 
%
%
%  SYNTAX
%
%  runningsmooth(t,y,T)
%  runningsmooth(t,y,T,1)  will use the legacy version (no interpolation)
%
%
%  EXAMPLE
%  t=cumsum(rand(1,25))
%  y=cumsum(rand(1,25))
%  runningsmooth(t,y,1.0)
%

if nargin<3;    help(mfilename);return;end

if nargin==3
    LEGACY=0;
end

if LEGACY==1
    disp(['warning - using LEGACY=1 version of running smooth'])
    disp(['(using non-interpolated data)'])
end


z=y;


%LEGACY=0;

if LEGACY==0;
    %first need to interpolate
    delt=mean(diff(t));
    ts=t(1):delt:t(end);
    
    ys=interp1(t,y,ts);
    
    
    ii=length(find( ts-ts(1) <=T));
    
    f=ones(1,ii)/ii;
    
    w=conv(ys,f);
    
    s=w;
    
    %h=floor((ii-1)/2);
    h=(ii-1)/2;
    
    s=s(h+1:end-h);
    
    %now interpolate back onto t grid
    
    zs=s(:).';
    ts=ts(:).';
    
    s=interp1([ts(1)-delt ts ts(end)+delt],[zs(1) zs zs(end)],t);
    
    if size(y,1)==1;
        s=s(:).';
    else
        s=s(:);
    end
else
    
    
    
    %now smooth. what is smoothing length?
    
    
    ii=length(find( t-t(1) <=T));
    
    f=ones(1,ii)/ii;
    
    w=conv(z,f);
    
    s=w;
    
    %h=floor((ii-1)/2);
    h=(ii-1)/2;
    
    s=s(h+1:end-h);
    
    
end


return



%% code to test this

t=.01:.01:10;
T=1;
y=sin(2*pi/T*t);
plot(t,y,t,runningrms(t,y,T/4),t,runningrms(t,y,T/2),t,runningrms(t,y,T),t,runningrms(t,y,2*T));
xlabel('sec')
ylabel('signal')
legend('inst. signal','T/4','T/2','T','2T');
title('Test of RunningRMS code')
fattenplot

%this code shows some promise but is awfully slow
ii=find(t<=t(end)-T);
delt=[0 diff(t)'].';
for j=1:length(ii);
    jj=find(t>t(ii(j)) & t< t(ii(j))+T);
    w(j)=sum(z(jj).*delt(jj));
end
