function s=runningrms(t,y,T);
% RUNNINGRMS - calculate running root mean square
%
% SYNTAX
% s=runningrms(t,y,T) - set s to running rms of y over time t with
% smoothing length T
%
% EXAMPLE
% t=.01:.01:10;
% T=1;
% y=sin(2*pi/T*t);
% plot(t,y,t,runningrms(t,y,T/4),t,runningrms(t,y,T/2),t,runningrms(t,y,T),t,runningrms(t,y,2*T));
% xlabel('sec')
% ylabel('signal')
% legend('inst. signal','T/4','T/2','T','2T');
% title('Test of RunningRMS code')
% fattenplot

z=y.^2;

%now smooth. what is smoothing length?

ii=length(find( t-t(1) <=T));

f=ones(1,ii)/ii;

w=conv(z,f);

s=(w).^(1/2);

h=(ii-1)/2;
s=s(h+1:end-h);

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
