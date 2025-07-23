function [T,f,w]=runningperiod(t,y,T,LEGACY);
% RUNNINGPERIOD  Finds local zero crossing period for a signal. 
%
% Output is a vector of periods.
%  runningperiod(t,y,T,1)  will use the legacy version (no interpolation in runningsmooth)
%
% EXAMPLE:
%
%t=.01:.01:10;
%T=1;
%subplot(211)
%y=sin(2*pi/T*t);
%plot(t,y,t,runningperiod(t,y))
%xlabel('sec')
%ylabel('inst period')
%legend('sine wave','running period')
%title('Test of RunningPeriod code')
%subplot(212)
%y=sin(2*pi/T*t.^1.2);
%plot(t,y,t,runningperiod(t,y))
%xlabel('sec')
%ylabel('inst period')
%title('Test of RunningPeriod code')
% legend('chirp','running period')
%fattenplot






%find zero crossings
y=y-mean(y);
ii=find(y==0);

if ~exist('T')
    T=.2;
end

if ~exist('LEGACY')
    LEGACY=0;
end

if LEGACY==0;
    y=runningsmooth(t,y,T);
elseif LEGACY==1;
    y=runningsmooth(t,y,T,1);
    disp(['warning - using LEGACY=1 version of running smooth'])
    disp(['(using non-interpolated data)'])
end

% if LEGACY==1
%     disp(['warning - using LEGACY=1 version of running smooth'])
%     disp(['(using non-interpolated data)'])
% end


T=0*t;


x=abs(y)./y;  %x is a vector of +/- one

a=diff(x); 

%jj=find(a~=0);
jj=find(a==2);  %just look at one type of crossing, divide by 2 at the end.



for m=1:length(jj)-1;
   T(jj(m):jj(m+1))=2*(t(jj(m+1))-t(jj(m)));
end
T=T./2;
f=1./T;
w=2*pi./T;

return



%% code to test this

t=.01:.01:10;
T=1;
subplot(211)
y=sin(2*pi/T*t);
plot(t,y,t,runningperiod(t,y))
xlabel('sec')
ylabel('inst period')
title('Test of RunningPeriod code')
subplot(212)
y=sin(2*pi/T*t.^1.2);
plot(t,y,t,runningperiod(t,y))
xlabel('sec')
ylabel('inst period')
title('Test of RunningPeriod code')
fattenplot

