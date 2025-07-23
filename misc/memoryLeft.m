function output = memoryLeft
%MEMORYLEFT Aproximates remaining RAM
%   memory left checks the operating system and uses different methods for
%   different operating systems
% For Windows uses the built in matlab memory function and truncates output 
% For MAC uses the bash top command and uses grep -> sed to format output
%
% Author: Sam Stiffman
% Date: 6/17/2019

if(strcmp(computer, 'PCWIN64'))
    output = truncate(memory.MaxPossibleArrayBytes);
else
    %Uses sed magic
    [~, text] = system('top -l 1 -s 0 | grep PhysMem | sed "s/PhysMem: [0-9]*[A-Z] used ([0-9]*[A-Z] wired), \([0-9]*[A-Z]\) unused./\1B/"');
    output = text(1:end-1);
end

% Truncates the output from the memory command and adds the suffix for
% example changes 1.2e10 => 12GB
function shortened = truncate(number)
    if number >= 1e+12
        number = number/1e+12;
        shortened = [num2str(number) 'TB'];
    elseif number >= 1e+9
        number = number/1e+9;
        shortened = [num2str(number) 'GB'];
    elseif number >= 1e+6
        number = number/1e+6;
        shortened = [num2str(number) 'MB'];
    elseif number >= 1e+3
        number = number/1e+3;
        shortened = [num2str(number) 'KB'];
    end
end
end

