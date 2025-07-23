function [ColorVector,ColorMatrix]=AllocateColors(cmapname,Values,caxislimits);
% AllocateColors   allocate colors 
%
%  Syntax
%    [COLORVECTOR,COLORMATRIX]=ALLOCATECOLORS(COLORMAP,VALUESVECTOR,[CAXISMIN CAXISMAX])
%  
%   
%  Example
%
%    ColorVector=AllocateColors('revautumn',GDDvals)
%    is the same as  
%    ColorVector=AllocateColors('revautumn',GDDvals,[min(GDDvals) max(GDDvals)]);


if nargin==2
  caxislimits=[min(Values) max(Values)];
end

try
  cmap=finemap(cmapname);
catch
  disp(['finemap didn''t work.  trying colormap'])
  cmap=colormap(cmapname);
end

Ncolors=length(Values);

kk=round(linspace(1,length(cmap),Ncolors));

kk=(Values-caxislimits(1))/(caxislimits(2)-caxislimits(1));  
% scaled from 0 to 1
kk=round(kk*length(cmap));
kk(kk<1)=1;
kk(kk>(length(cmap)))=length(cmap);

for j=1:Ncolors;
  ColorVector{j}=cmap(kk(j),1:3);
  ColorMatrix(j,1:3)=cmap(kk(j),1:3);
end
