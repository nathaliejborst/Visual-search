% UITLEGGGGG
% UITLEGGGGGG

% load data from participant
participant = load('run_experiment13334212.mat').dataBlock;

condition = {'dcol', 'dsym', 'c'};
setSize = [8 24 40 56];
conditionColors = {[0.0148, 0.7104, 0.1482], [0.9765, 0.4314, 0.2000], [0.1200, 0.2627, 0.7176]};

figure

conditionHistory = {participant(:).condition};  % get the history of all conditions for the participant
RTHistory = [participant(:).RT];    % get the history of all reaction times for the participant

meanRTs = [];    % initialize empty array for coordinates mean reaction times per condition

t = timer('TimerFcn', 'stat=false; disp(''Timer!'')',... 
                 'StartDelay',10);
             
start(t)
stat=true;
while(stat==true)
  disp('.')
  pause(0.3)
end

%% Get reaction times for all conditions per set size and plot these
for i = 1:length(condition) % loop through all conditions
    conditionIndx = strcmp(conditionHistory, string(condition(i))); % logical array with index where current condition 
    for j = 1:length(setSize)   % loop through all set sizes
        sizeIndx = [participant(:).setSize] == setSize(j);   % logical array with index where current set size
        RT = RTHistory(conditionIndx & sizeIndx);  % get all reaction times for i'th condition and j'th set size 

        for k = 1:length(RT)    % loop through all reaction times to add to figure
            scatter(setSize(j), RT(k), [], cell2mat(conditionColors(i))); % place dot in scatter with color for current condition
            hold on
%             fprintf('Executing program, coordinates: x=%i, y=%d - %s \n',setSize(j), RT(k), string(condition(i))); 
        end
        meanRTs(j) = mean(RTHistory(conditionIndx & sizeIndx));  % add mean reaction time to vector for i'th condition
    end
    p(i) = plot(setSize, meanRTs, 'Color', cell2mat(conditionColors(i)));  % plot mean reaction times per set size for i'th condition
    hold on
end

%% design figure
xlabel('Number of objects in stimulus', 'FontSize', 12);    % add title to y-axis
ylabel('Reaction time (s)', 'FontSize', 12);    % add title to x-axis
legend(p,{'pop-out color','pop-out symbol', 'conjunctive'},'Location','northwest')  % add legend for every condition
box on  % put box around figure
grid on     % add a grid to the figure
hold off

stat=false;