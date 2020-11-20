participant = load('run_experimentNaN.mat').dataBlock

condition = {'dcol', 'dsym', 'c'};
setSize = [8 24 40 56];

c = convertCharsToStrings({participant(:).condition});
setS = [participant.setSize];
indexC = c == 'c'
index8 = setS == 8

% multiply to get index where both condition and set size is true
trueIND = logical(indexC.*index8)

RT = [participant.RT];
TR = [participant.trial];


conditionsArray = convertCharsToStrings({participant(:).condition});    % array with all conditions as string from data
setsizeArray = [participant.setSize];   % array with all set sizes from data

%% Get reaction times for all conditions per set size
for i = 1:length(condition) % loop through all conditions
    currentCondition = string(condition(i));    % get current condition as string
    condition_i = conditionsArray == currentCondition;  % logical array with index where current condition
    for j = 1:length(setSize)   % loop through all set sizes
        currentSS = setSize(j); % get current set size
        setSize_i = setsizeArray == currentSS;  % logical array with index where current set size
        bothCorrect = logical(condition_i.*setSize_i);  % logical array with index where current condition & set size
        TR(bothCorrect)
        fprintf("%s & %i", string(condition(i)), setSize(j))
    end
    
end


conditionHisto = {participant(:).condition}
indx = strcmp(conditionHisto, 'c')
setIndx = [participant(:).setSize] == 8

