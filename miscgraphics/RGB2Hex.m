function hexValue = RGB2Hex(red, green, blue)
%% RGB2Hex - Takes in a red green and blue float value from [0,1], or an rgb integer value from [1,255] and converts them to a hex
% string
%
% Examples
% RGB2Hex(0,0.2,0.3) %% returns "#00334D"
% RGB2Hex(25,255,1)  %% returns "#19FF01"
%
% By default 1's are taken to be [0,255] however when mixed with any
% number <1 they will be interpreted as being between [0,1]
% RGB2Hex(1,1,1)     %% returns "#010101"
% RGB2Hex(1,1,.11)   %% returns "#FFFF1C"
%
% There is an assertion making sure that the input is valid 
% RGB2Hex(1,10,.11) 
% will not work since some values are [0,1] and some are [0,255]
%%
assert((red <= 1 && green <= 1 && blue <=1) || (red >= 1 && green >= 1 && blue >=1));

if red > 1 && green > 1 && blue > 1
    % RGB values do not need to be converted but must be integer type
    hexVals = int16([red,green,blue]);
else
    % RGB values need to be converted from [0,1] => [0,255]
    hexVals = int16([red * 255, green * 255, blue * 255]);

end

% the 2 is needed in dec2hex so matlab will always print out a 6 digit hex number  
str = string(dec2hex(hexVals, 2));
hexValue = join(["#", join(str,"")],"");


end