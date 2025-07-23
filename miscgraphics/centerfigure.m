function O=centerfigure(I)
% centerfigure - fix an off center NiceSurf figure image
%
% SYNTAX
% centerfigure('filename') will load and center image 'filename' and resave
% it while returning the centered image
% centerfigure(image) will return 'image' centered
%
% NOTES
% Only works with NiceSurf and similar figures that aren't too far from the
% default output.
%
% EXAMPLES
% nsg(magic(15));
% outputfig('force','example.png');
% centerfigure('example.png');
%
% See Also
saveto=[];

% If given a string, assume it's an image file name; load the image,
% remember the path
if (isstr(I))
    saveto=I;
    I=imread(I);
end

% When determining the extent of the map itself (the part that needs to be
% centered) a certain amount of tolerance is used to account for imperfect
% image quality
tol=max(max(max(I)))/1000;

% Find the background color of the image
c1=I(1,1,1);
c2=I(1,1,2);
c3=I(1,1,3);

% Determine the x-axis extent of the map
centerrow=I(round(size(I,1)/2),:,:);
tmp=1:length(centerrow);
find(closeto(centerrow(:,:,1),c1,tol)&...
    closeto(centerrow(:,:,2),c2,tol)&...
    closeto(centerrow(:,:,3),c3,tol))
tmp(find(closeto(centerrow(:,:,1),c1,tol)&...
    closeto(centerrow(:,:,2),c2,tol)&...
    closeto(centerrow(:,:,3),c3,tol)))=0;
left=nearestNonZero(1,1,tmp);
right=nearestNonZero(1,length(tmp),tmp);

% Calculate the number of pixels off center the map is
offset=round((left+right-length(tmp))/2);

% Determine the y-axis extent of the map
tmp1=1:size(I,1);
means=zeros(size(I,1),3);
for i=1:length(means)
    means(i,1)=mean(I(i,:,1));
    means(i,2)=mean(I(i,:,2));
    means(i,3)=mean(I(i,:,3));
end
tmp1(find(~closeto(means(:,1),c1,tol/100)|...
    ~closeto(means(:,2),c2,tol/100)|...
    ~closeto(means(:,3),c3,tol/100)))=0;
top=nearestNonZero(1,round(length(tmp1)/2),tmp1(1:round(length(tmp1)/2)));
bottom=nearestNonZero(1,1,tmp1(round(length(tmp1)/2):length(tmp1)));
%save imsavedata

% Render a new image, correcting the map's placement according to the
% variables found above
O=I;
O(top:bottom,:,1)=c1;
O(top:bottom,:,2)=c2;
O(top:bottom,:,3)=c3;
size(O)
size(I)
offset
if (offset>0)
    O(top:bottom,1:(size(O,2)-offset),:)=I(top:bottom,1+offset:size(I,2),:);
else if (offset<=0)
    O(top:bottom,1-offset:size(O,2),:)=I(top:bottom,1:(size(I,2)+offset),:);
    end
end
        
% If initially given a file name, resave the image to that file
if ~isempty(saveto)
    imwrite(O,saveto);
end