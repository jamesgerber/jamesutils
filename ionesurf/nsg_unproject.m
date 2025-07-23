function longlatbox=nsg_unproject(longlatbox);
%nsg_unproject - ad-hoc unprojection of robinson mapping
%
%  i have a problem with nsg, which is that if I tell mapping toolbox to
%  plot the exact locations of australia via long/lat, then I have a
%  problem wherein the plot is biased towards 0 degrees long.  This
%  attempts to unbias.  it is totally ad-hoc and somewhat embarassing.
%  maybe a geographer could fix.


bb=longlatbox;

m=mean([bb(1) bb(2)])
del=bb(2)-bb(1);
x1= (m-del*1.0)*cosd(m/4);
x2=(m+del*1.0)*cosd(m/4);
m=mean([bb(3) bb(4)])
del=bb(4)-bb(3);
y1= (m-del*1.0);
y2=(m+del*1.0);

longlatbox=[x1 x2 y1 y2];
