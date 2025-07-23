function Location=NextButtonCoords;
% NEXTBUTTONCOORDS - determine button location

persistent c
if isempty(c)
  c=1;
end


dely=25;
delx=120;
spacey=5;
spacex=0;
initialy=7.5;
initialx=5;



Location=[initialx  (initialy+(c-1)*(spacey+dely)) delx dely];

c=c+1;
