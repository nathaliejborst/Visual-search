% This is the script for running the Treisman Visual Search experiment
% Prompt for studentnumber, trials and percentage
prompt = {'Studentnumber participant:','Number of trials', 'Percentage'};
answer = inputdlg(prompt,'Input experiment info',1,{'','600','0.8'})    % show input dialog with default trials and target percentage

% questdlg("Start Experiment", "TITLE", 'No')   % start button to start

studentID = str2double(answer(1));
trials = str2double(answer(2));
percentage = str2double(answer(3));


%% Initialize data block
% studentID = 1089030;
% trials = 100;
% percentage = 0.8;
condition = {'dcol', 'dsym', 'c'};
setSize = [8 24 40 56];
dataBlock = struct.empty(600,0);  % pre-allocate struct for trial data with maximum amount possible of trials
breaks = struct.empty(8,0);   % pre-allocate struct breaks in experiment

% data(35) = struct('reactiontime', [], 'condition', [], 'trial', []);

%% Show instructions block
figure('Color', [0 0 0],'units','normalized','outerposition',[0 0 1 1],'menubar','none')    % remove menubar and set fullscreen
line1 = text(0.5, 0.6, 'Press a button to start the block'); % show instructions
line2 = text(0.5, 0.5, 'Press ''y'' if you see a target and ''n'' if the target is absent');    % show instructions
set(gca,'visible','off','xlim',[0 1],'ylim',[0 1]); % remove the axis and set limits
set(line1,'visible','on','HorizontalAlignment','center')    % center the first instruction line
set(line2,'visible','on','HorizontalAlignment','center')    % center the second instruction line
set(gcf,'color','w')    % set background color to white

pause   % wait for button press
clf   % clear instructions

%% Create table with counters for the hit target 
dcol = zeros(4,1);   % fill column with zeros
dsym = zeros(4,1); % fill column with zeros
c = zeros(4,1); % fill column zeros
hitTable = table(dcol, dsym, c, 'RowNames', string(setSize)) % initialize the table with row- and columnnames

correctCounter = 0;
failCounter = 0;

%% Run experiment for given trials
for i = 1:trials
    set(gcf, 'Name', ['Trial:  ',num2str(i)])   % show trial number in title
    %% Determine if there's a target
    if rand>percentage  % if random number is above target probability, set no target
      target=0;
    else    % if below percentage, set target
      target=1;
    end
    
    % Randomize condition
    c = char(condition(randi(length(condition))));
    
    % Randomize set size
    n = setSize(randi(length(setSize)));
    
    %% Register trial data participant
    dataBlock(i).ppn = studentID;   % register partipant
    dataBlock(i).trial = i; % register trial
    dataBlock(i).condition = c; % register condition
    dataBlock(i).setSize = n;   % register set size
    dataBlock(i).target = target;   % register target
    [dataBlock(i).RT, dataBlock(i).correct, dataBlock(i).buttonPress] = do_experiment(n, c, target); % register reactiontime, correct and button pressed    
    
    %% Check if there's a target and if response is correct
    if target && dataBlock(i).correct
        hitTable{string(n),c} = hitTable{string(n),c} + 1; % increase counter by 1 for the set size and condition combination    
    end
    
    hitTable
    
    % Stop trials if all 12 counters are at least 20
    if sum(hitTable{:,:} >= 20, 'all') >= 12
        fprintf('gelukt???');
        break
    end
    
    %% Increase correct and fail counters
    correctCounter = correctCounter + dataBlock(i).correct;
    failCounter = failCounter + not(dataBlock(i).correct);
    
    % Show warning when less than 75% of last 50 trials is correct
    if (correctCounter + failCounter)>=50   % check when equal or larger than 50 
        if (failCounter/correctCounter)>=0.25   % show warning when at least 25% of last 50 trials is incorrect
            uiwait(warndlg("75% of last 50 trials were incorrect")); % give a warning to participant
            [correctCounter, failCounter] = deal(0,0)   % reset counters back to 0
        end
    end
    
    failCounter;
    correctCounter;
    
    %% Give the user a break after every 75 trials
    if mod(i,75) == 0
        tic;    % Start timer for break
        text(0.5, 0.6, 'Take a break. As soon as you''re ready press any button to continue'); % show instructions 
        set(gca,'visible','off','xlim',[0 1],'ylim',[0 1]); % remove the axis and set limits
        pause
        dataBlock(i).break = toc;    % Stop timer after participant presses button
        clf     % clear figure
    end 
end

% Close figure
close

% Save data participant in a .mat
save(['run_experiment' num2str(studentID) '.mat'],'dataBlock')
 

