function inflatedfid=inflateintegerblobs(fidmatrix,target,Nextend);
% inflateintegerblobs - extend a discrete value raster.
%
%      inflatedfid=inflateintegerblobs(fidmatrix,target,Nextend);
%
%     Default Nextend=10
%
%    INputs:
%     fidmatrix - discrete values against a background of 0
%     target  - logical matrix, same size as fidmatrix
%   Outputs:
%     inflatedfid - discrete values with coverage where target==1
%     
%     this is useful if there are points that are just outside a raster of
%     categories (such as admin units) and the goal is to extend that
%     categorical raster to a more incluse landmask ('target')
%
%     this code takes each individual blob and runs a convolution operator
%     (convolution with a square block).   each point in 'target' but
%     not in 'fidmatrix' is assigned to the blob whose convolution has
%     the greatest value at that point.  (Note that that isn't necessarily
%     the closest point)


%     J Gerber
%     University of Minnesota, 2024


if nargin==3
    Nextend=10;
end


if fidmatrix(1)~=0
    error(' expected a zero background - 1st element is non-zero ')
end


inflatedfid=fidmatrix;

fidvalues=unique(fidmatrix);
fidvalues=fidvalues(fidvalues~=0);


block=ones(Nextend,Nextend);

storedistance=ones(size(fidmatrix))*1e20;


for jfid=1:numel(fidvalues);
    
    fid=fidvalues(jfid);
    ii=fidmatrix==fid;
    
    
    extended=conv2(ii,block,'same');

    jj=extended>0;

    distance=extended;
    kk=(inflatedfid==0 & target==1);
    kk=(jj & inflatedfid==0 & target==1 & storedistance > distance);
    
    inflatedfid(kk)=fid;
    storedistance(kk)=distance(kk);
end

inflatedfid(target==0)=0;


    