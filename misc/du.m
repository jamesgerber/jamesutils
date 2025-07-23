function du
% execute du command in unix (space in directories)
if isunix
    disp(['calling du -h -d1, could be slow'])
    [s,w]=unix('du -h -d1');
else
    disp(' not unix ')
    return
end

% with a few edits, the code below was ChatGPT Oct 4, 2024


lines=splitlines(w(1:end-1));

% Initialize cell arrays for the columns
sizes = cell(length(lines), 1);
names = cell(length(lines), 1);

% Loop through each line and split into two columns
for i = 1:length(lines)
    % Split each line into size and name based on tab character
    splitLine = split(lines{i}, '	'); % Using tab character
    sizes{i} = strtrim(splitLine{1});  % First column (Size)
    names{i} = strtrim(splitLine{2});  % Second column (Name)
end

% Convert sizes to a numeric format for sorting
numericSizes = zeros(length(sizes), 1);
for i = 1:length(sizes)
    sizeStr = sizes{i};
    if endsWith(sizeStr, 'B')
        numericSizes(i) = str2double(sizeStr(1:end-1)); % Bytes
    elseif endsWith(sizeStr, 'K')
        numericSizes(i) = str2double(sizeStr(1:end-1)) * 1e3; % Kilobytes
    elseif endsWith(sizeStr, 'M')
        numericSizes(i) = str2double(sizeStr(1:end-1)) * 1e6; % Megabytes
    elseif endsWith(sizeStr, 'G')
        numericSizes(i) = str2double(sizeStr(1:end-1)) * 1e9; % Gigabytes
    else
        numericSizes(i) = str2double(sizeStr); % Assume it's in Bytes if no unit
    end
end

% Sort the sizes and corresponding file names
[sortedSizes, sortIdx] = sort(numericSizes);
sortedSizes = sizes(sortIdx);
sortedNames = names(sortIdx);

% Create a new table with sorted results
sortedTable = table(sortedSizes, sortedNames, 'VariableNames', {'Size', 'FileName'});

% Display the sorted result
disp(sortedTable);