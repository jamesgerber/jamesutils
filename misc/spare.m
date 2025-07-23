function spare(varargin);
%SPARE - Clears all variables from base workspace except for input arguments
%
% Syntax:
% spare X1 X2   %Clears all variables except X1 X2 from base workspace

% JSG 
sparelist=varargin;

if nargin==0
    help(mfilename)
    return
end

if nargin==1
    if ~ischar(sparelist{1})
        disp(['must input variable names, not variable values'])
    return
    end
end

S=evalin('base','whos');




for j=1:length(S)
   if ~any(strcmp(S(j).name,sparelist));
      evalin('base',['clear ' S(j).name]);
   else
      disp(['Sparing ' S(j).name ])
   end
end
   