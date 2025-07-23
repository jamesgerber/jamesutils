function D=CBMDaylight(J,Latitude)
%CBMDaylight - calculate hours of daylight according to CBM model
%
% SYNTAX
% CBMDaylight(J,Latitude) - where J is the number of days past the March
% equinox and Latitude is the latitude, return the number of hours of
% daylight
%
%  See W.C. Forsythe et al. / Ecological Modelling 80 (1995) 87-95

if nargin==0
    help(mfilename)
    return
end



L=Latitude;
p=0;

theta=0.2163108 + 2* atan( 0.9671396 *tan(0.00860*(J-186)));
phi=asin(0.39795*cos(theta));
D=24-24/pi*acos( (sin(p*pi/180) + sin(L*pi/180)*sin(phi) ) ...
		 ./ ...
		 (cos(L*pi/180)*cos(phi)));

D=real(D);
