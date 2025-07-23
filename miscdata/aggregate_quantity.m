function small=aggregate_quantity(big,N,nanflag,smallclass)        
%aggregatequantity - aggregate quantity data down to a coarser scale
%
% Syntax:
%   aggregate_quantity(bigmatrix,N)
%
%   aggregate_quantity(bigmatrix,N,'NANFLAG')
%   aggregate_quantity(bigmatrix,N,'NANFLAG',smallclass)
%   aggregate_quantity(bigmatrix,N,'',smallclass) 
%
%    where 'NANFLAG' can be 
%     'hidden' or 'average' - NaN values will be treated as 'missing' data
%     and replaced with the average value of the non-nan values found at
%     the smallest level of aggregation.
%     'sum'  - NaN values will be treated as zero
%     'kill' - any NaN values at the highst resolution will lead to a NaN
%     values for the associated aggregated cell. (Default)
%
% EXAMPLE
%   A=testdata;
%   B=aggregate_quantity(A,5);
%
% [  1 1 1 
%  NaN 1 1       ->   "hidden"  ->  [9]
%  NaN 1 1]  
%
% [  1 1 1 
%  NaN 1 1       ->   "sum"  ->  [7]
%  NaN 1 1]  
%
% [  1 1 1 
%  NaN 1 1       ->   "kill"  ->  [NaN]
%  NaN 1 1]  
%
%
%
%
% See also:  aggregate_rate

% special case ... if big is a row or column vector, want to expand with
% repmat.  Then can still do box stuff down below (very fast)
if size(big,1)==1  
    big=repmat(big,N,1);
elseif size(big,2)==1
    big=repmat(big,1,N);
end



% may need to make big a tiny bit bigger

x=size(big);
if rem(x(1),N)==0 & rem(x(2),N)==0
    % don't need to change anything
else
    % need to tack some extra stuff onto end of big so that accelerated
    % methods below will still work (i.e. parsing into columns, squares,
    % etc.)    
    warning([ 'Expanding size of input matrix in ' mfilename ' to allow ' ...
        'integer aggregation.  This may lead to issues at boundaries']);
    newr=N*ceil(x(1)/N);
    newc=N*ceil(x(2)/N);
    big(newr,newc)=0;
end


if nargin<3 
    nanflag='kill';
end

if  isempty(nanflag)
    nanflag='kill';
end

if nargin<4
    smallclass='double';
end

switch lower(nanflag)
    case 'kill'

        small=zeros(size(big)/N,smallclass);
        for m=1:N
            for k=1:N
                small(:,:)=small(:,:)+big(m:N:end,k:N:end);
            end
        end
    case {'hidden','average'}
        correctionfactor=aggregate_rate(isfinite(big),N,'kill',smallclass);
        big(isnan(big))=0;
        x=aggregate_quantity(big,N,'kill',smallclass);
        small=x./correctionfactor;
    case {'sum'}
        big(isnan(big))=0;
        small=aggregate_quantity(big,N,'kill',smallclass);
    otherwise
        error(' syntax of aggregate_quantity has been changed ');
end
  


