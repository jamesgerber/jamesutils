function ic = iclosest(x1, x2) ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   c:/Kate/matlab_programs/.../iclosest ;
%
% DESCRIPTION
%   A program to find the index of the closest value of x2 to x1
%  
% INPUT
%          x1 - The lookup time series (vector)        
%          x2 - The value to be found (single value)
% OUTPUT
%
%
% EXAMPLE 
%   ic = iclosest(x1, x2) ; 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KAE 2004  modified by JSG 2009
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ic = find(abs(x1 - x2) == min(abs(x1 - x2))) ;
if length(ic)>1
    ic=ic(1);
end
