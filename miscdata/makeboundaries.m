function NewArray=MakeBoundaries(ctry,RegionValues);
% MAKEBOUNDARIES - Turn raster array of values into logical array of boundaries
%
% SYNTAX
%
%   NewArray=MakeBoundaries(ctry);
%    This will return a matrix NewArray of the same size as ctry in
%    which borders of all regions have the value 1, and
%    all other points have value 0.  A region is defined as any set
%    of contiguous points within ctry with equal non-zero values.
%    This code is particularly useful on datasets which have some
%    value corresponding to a political regions.
%
% EXAMPLE
%   boundaries=MakeBoundaries(round(testdata*3));


switch nargin   %nargin is a built-in matlab function which returns the number of arguments that this was called with.
    case 0   %called with zero arguments.  print out some help and return.
        help(mfilename);return
    case 1  %only one argument.  user didn't specify which Region (Country) values to use.  We will use all of them.
        Values=unique(ctry);   %make a unique vector of all values in the file:  this is all of the countries.
        Values=setdiff(Values,0);  %take out zero since that is probably the ocean.
    case 2
        Values=RegionValues;
    otherwise
        error('don''t know what to do with this many arguments')
end

NewArray=0*ctry;  %make a big blank array.  Same size.  This will be a logical array.  

for j=1:length(Values);
    Boundaries=EstablishBoundaries(ctry,Values(j));
    NewArray=NewArray | Boundaries;  %Logical addition.
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ESTABLISHBOUNDARIES     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Boundaries=EstablishBoundaries(ctry,Value);
%ESTABLISHBOUNDARIES - create a logical array corresponding to boundaries
%of a region within the array ctry.   The region is defined by the points
%where ctry is equal to Value.


%Now make array everywhere equal to 0 and 1 where it was== Value

ii=find(ctry==Value);  %beware! confusing matlab construct here.  
%  ii denotes the indices of the 2-D array which are equal to Value
% what is confusing is fact that ii is a vector of numbers (not an array)
% an yet it is used to index into an array.  Don't worry ... matlab lets
% you do this.


temparray=ctry*0;   % now make a big array of zeros
temparray(ii)=1;    % now make all the locations of interest (i.e. corresponding to region or country) equal to 1.

Boundaries=ctry*0;  % this will  be the logical array we build in the next loops.


% now temparray has properties we want.

[R,C]=size(temparray);  %get number of rows and columns.

%first do rows
for j=1:R
    
    row=temparray(j,:);
    ydown=diff(row);
    ydown(end+1)=0;  %use matlab special syntax to tack a zero on at the end
    
    yup=diff(row);
    yup=[0 yup(:)']; %use matlab "[  ]" concatenation to tack a zero on at the beginning
    % note that yup(:) makes a column vector
    % then yup(:)' makes a row vector    
    
    uplocations=(yup==1);
    downlocations=(ydown==-1);
    % now perform a logical addition of these three C element row vectors
    Boundaries(j,:)=Boundaries(j,:) | uplocations | downlocations;
end
for j=1:C;
    col=temparray(:,j);
    ydown=diff(col);
    ydown(end+1)=0;
    ydown=ydown(:);
    
    yup=diff(col);
    yup=[0 yup(:)'];
    yup=yup(:);
    %  embarassing code above.  trying to prepend a 0 to a column vector
    % should be done like this:  yup=[0 ; yup];
    
    uplocations=(yup==1);
    downlocations=(ydown==-1);
    
    Boundaries(:,j)=Boundaries(:,j) | uplocations | downlocations;
end




