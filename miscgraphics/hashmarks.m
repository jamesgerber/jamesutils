function I=hashmarks(im,mask,color,space,width,dir,filename)
% HASHMARKS - creates image of a map with hashmarks over a designated area
% 
% SYNTAX
% hashmarks(im,mask) where both im and mask are either 2-D global data
% arrays or map images, and where all but the designated areas to mark are
% a solid color or 0 in mask, will put black, diagonal hashmarks on the map
% on the indices designated by mask, and return an image of the map.
%
% hashmarks(im,mask,color,space,width,dir,filename) will give the hashmarks
% the color "color", put them "space" pixels apart, width of "width"
% pixels, direction "dir" (where 0 is vertical, 1 is horizontal, .5 is
% diagonal up, 1.5 or -.5 is diagonal down, etc), and save at "filename" in
% addition to returning the image.
%
% NOTES
% Slow and likely to freeze MATLAB. No anti-aliasing. Can't do more than
% one type of hashmark without user nesting functions. Doesn't correct user
% entered colors if they don't match the image type. Assumes format matches
% NSG defaults. Width argument can be challenging.
%
% EXAMPLES
% S=OpenNetCDF([iddstring '/Crops2000/crops/maize_5min.nc']);
% cropgrid=S.Data(:,:,4);
% I=hashmarks(hashmarks(cropgrid,(cropgrid>.5&cropgrid<=1.0)),(cropgrid>.9&cropgrid<=1.0),[0 0 255],8,2,0,'myhashmarks.png');
%
% See Also


if size(im,3)==1
    nsg(im);
    OutputFig('force','tmpim.png');
    %centerfigure('tmpim.png');
    im=imread('tmpim.png');
    %image(im);
    delete('tmpim.png');
end
if size(mask,3)==1
    mtnicesurfgeneral(mask);
    outputfig('force','tmpmask.png');
    %centerfigure('tmpmask.png');
    mask=imread('tmpmask.png');
    %image(mask);
    delete('tmpmask.png');
    % Default max color for NSG
    c1=0.0*256;
    c2=0.243*256;
    c3=0.153*256;
else
    c1=mask(1,1,1);
    c2=mask(1,1,2);
    c3=mask(1,1,3);
end
close all;
if (nargin<3)
    color=[0.0,0.0,0.0];
end
if (nargin<4)
    space=size(im,2)/200;
end
if (nargin<5)
    width=space/10;
end
if (nargin<6)
    dir=.5;
end
tol=maxval(mask)/32;
for i=1:size(im,1)
    for j=1:size(im,2)
        if (closeto(mask(i,j,1),c1,tol)&&closeto(mask(i,j,2),c2,tol)&&closeto(mask(i,j,3),c3,tol))
            if closeto(0,mod(i*sin(dir*pi/2)+j*cos(dir*pi/2),space),width)
                im(i,j,1)=color(1);
                im(i,j,2)=color(2);
                im(i,j,3)=color(3);
            end
        end
    end
end
I=im; 
if (nargin==7)
    imwrite(I,filename);
end