function handle=plotcomplex(t,z,t2,z2);
% PLOTCOMPLEX   plot a complex vector 
%
%  Syntax:
%
%   h=plotcomplex(Z); - plot vector Z over 1:length(Z)
%
%   h=plotcomplex(t,Z); - plot vector Z over t
%
%   h=plotcomplex(t,Z,style); - style indicator will be used with plot
%
%   h=plotcomplex(t,Z,t2,Z2); - plot both Z over t and Z2 over t2
%
%
%  EXAMPLE
%   v=cumsum(rand(1,5)*i+rand(1,5));
%   t=cumsum(rand(1,5));
%   plotcomplex(t,v);


if nargin==1
   z=t;
   t=1:length(z);
   strname=inputname(1)
else
      strname=inputname(2);
end
 
if nargin==3
    style=t2;
else
    style='-';
end



if nargin<4
    subplot(211)
    h(1)=plot(t,real(z),style);
    legend(['real(' strname ')']);
    grid on
    
    subplot(212)
    h(2)=plot(t,imag(z),style);
    grid on
    legend(['imag(' strname ')']);
    if nargout==2
        handle=h;
    end
    return
end


if nargin==4
      strname1=inputname(2);
      strname2=inputname(4);

    subplot(211)
    h(1:2)=plot(t,real(z),t2,real(z2),style);
    legend(['real(' strname1 ')'],['real(' strname2 ')']);
    grid on
    
    subplot(212)
    h(3:4)=plot(t,imag(z),t2,imag(z2),style);
    legend(['imag(' strname1 ')'],['imag(' strname2 ')']);
    grid on
    if nargout==2
        handle=h;
    end
    return
end