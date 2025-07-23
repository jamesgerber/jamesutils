
function outputfilename=newhashmarks(mapfilename,maskfilename,newfilename,color,space,width,dir,offset)
% newhashmarks - put hashmarks on a .png file
%
% SYNTAX:  newhashmarks(mapimagefilename,maskfilename)
%
%
%      where mapimagefilename  = name of a file with a map in .png format
%            maskimagefilename = name of a file with a mask in .png format
%            
%            mapimagefilename and maskimagefilename can also be passsed
%            directly as matrix objects
%
%            wherever the map image = red ( [1 0 0 ] in RGB values), the
%            mask image will be covered with hashmarks.  output will go to
%            "mapimagefilename_hash.png"
%
%     additional options
%
%        newhashmarks(mapfilename,maskfilename,newfilename,color,space,width,dir);
%
%                 newfilename - output name for file
%                 color       - color for hashmarks in rgb
%                 space       - spacing for hashmarks
%                 width       - width of hashmarks
%                 dir         - direction of hashmarks in degrees where 0
%                               is horizontal and 90 is vertical
%                 offset      - offset (so that parallel stripes don't
%                               overlap)
%              
%  Recommended resolution at least: 600
%  OK to pass in empty arrays to get defaults
%
%   Example:
%
% ii=countrycodetooutline('USA');
% jj=ones(size(ii))+double(ii);
%
% OS=nsg(landmasklogical,'filename','testhashmarks.png','resolution','-r600');
% OS2=nsg(ii==1,'filename','testmask.png','cbarvisible','off','cmap',[0 0 0;0 0 0;0 0 0; 1 0 0],'resolution','-r600');
% Simple Example makes blue hashmarks with default spacing and width at a 45degree angle:
% newhashmarks(OS.ActualFileName,OS2.ActualFileName,'testfigwithhashmarks1.png',[0,0,1],[],[],[45])
% More complex Example makes hashmarks with multiple hashmarks
% newhashmarks(OS.ActualFileName,OS2.ActualFileName,'testfigwithhashmarks2.png',[],50,[],[0,45])


% Checks if the newfilename argument has been specified
if nargin<3 || isempty(newfilename)
    mapfilename=fixextension(mapfilename,'.png');
    newfilename=strrep(mapfilename,'.png','_hash.png');
else
    newfilename=fixextension(newfilename,'.png');
end

im = mapfilename;
mask = maskfilename;
% Checks to see if the image and mask are strings or else it treats them as
% matrices
if ischar(mapfilename)
    im=imread(fixextension(mapfilename,'.png'));
    if ischar(maskfilename)
        mask = imread(fixextension(maskfilename,'.png'));
    end
else
  if ischar(maskfilename)
    mask=imread(fixextension(maskfilename,'.png'));
    if ischar(mapfilename)
        im=imread(fixextension(mapfilename,'.png'));
    end
  end
end

% Default argument values
if nargin<4 || isempty(color)
    color=[0.0,0.0,0.0];
end
if nargin<5 || isempty(space)
    space = size(im,2)/150;
end
if nargin<6 || isempty(width)
    width=space/10;
end
if nargin<7 || isempty(dir)
    dir=135;
end
if nargin<8 || isempty(offset)
    offset=0;
end


%Tolerance for determining if the color matches red
tol=maxval(mask)/32;

% Colors to check for matching 
c1=255;   % This is red
c2=0;
c3=0;

legacy=0;

if legacy==1
    tic
    for i=1:size(im,1)
        for j=1:size(im,2)
            % Checks if mask band values are close to 255,0,0 tolerance
            % allows values to differ
            %if(closeto(mask(i,j),[c1,c2,c3],tol))
             if (closeto(mask(i,j,1),c1,tol) && closeto(mask(i,j,2),c2,tol) && closeto(mask(i,j,3),c3,tol))
                %if closeto(0,mod(i*sin(dir*pi/2)+j*cos(dir*pi/2),space),width)
                if closeto(0,mod(j,space),width)
                    im(i,j,1)=color(1);
                    im(i,j,2)=color(2);
                    im(i,j,3)=color(3);
                end
            end
        end
    end
    toc
else
    tic
    
    % Temporary matrices used to make the hashmarks
    tempi = 1:size(im,2);
    tempj = (1:size(im,1))';
    tempi = repmat(tempi,size(im,1),1);
    tempj = repmat(tempj,1,size(im,2));
    
   

%    hashmark = closeto(0, mod(tempi*sind(dir(1))+tempj*cosd(dir(1)), space),width);
    hashmark = closeto(0, mod(tempi*sind(dir(1))+tempj*cosd(dir(1))+offset, space),width);
   
    % Makes a mask where the values on the map match the color red
    redMask = closeto(mask(:,:,1),c1,tol) & closeto(mask(:,:,2),c2,tol) & closeto(mask(:,:,3),c3,tol);
    hashmark = redMask & hashmark;
   
    % A temporary logical matrix used to select where on the map the colors
    % should be changed
    iichangetohashmark=hashmark;
    
    
    % Changes the color at every point where there would are hashmarks on
    % the actual map
    for mm=1:3
      tempimlayer=im(:,:,mm);
      
      tempimlayer(iichangetohashmark)=floor(color(mm)*255);
      im(:,:,mm)=tempimlayer;
    end
    
    % If direction argument is a vector 
    if (length(dir) > 1)
        newhashmarks(im,maskfilename,newfilename,color,space,width,dir(2:end));
    end
   toc
end

imwrite(im,newfilename);

if nargout==1
    outputfilename=newfilename;
end