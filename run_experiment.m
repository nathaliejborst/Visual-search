% UITLEGGGGG
% UITLEGGGGG
% This is the script for running the Treisman Visual Search experiment
% Prompt for studentnumber, trials and percentage
prompt = {'Studentnumber participant:','Max. number of trials', 'Target probability'};
answer = inputdlg(prompt,'Input experiment info',1,{'999999','600','0.8'})    % show input dialog with default trials and target percentage

% get the eperiment details from prompt gui
studentID = str2double(answer(1));
trials = str2double(answer(2));
percentage = str2double(answer(3));

save('Data/run_experiment','answer');

%% Initialize experiment data
condition = {'dcol', 'dsym', 'c'};
setSize = [8 24 40 56];
dataBlock = struct.empty(600,0);  % pre-allocate struct for trial data with maximum amount possible of trials
breaks = struct.empty(8,0);   % pre-allocate struct breaks in experiment

%% Show welcome block
figure('Color', [0 0 0],'units','normalized','outerposition',[0 0 1 1],'menubar','none')    % remove menubar and set fullscreen
line1 = text(0.5, 0.6, 'Welcome to the visual search task! In this experiment you have to look for one object that''s different from the other objects: a target', 'FontSize', 14); % show instructions
line2 = text(0.5, 0.5, 'Your job is to find if there''s a target or not. Good luck! You first start with a few practice trials','FontSize', 14);    % show instructions
line3 = text(0.5, 0.4, 'Press any button to continue','FontSize', 14);    % show instructions
set(gca,'visible','off','xlim',[0 1],'ylim',[0 1]); % remove the axis and set limits
set(line1,'visible','on','HorizontalAlignment','center','VerticalAlignment', 'middle')    % center the first line
set(line2,'visible','on','HorizontalAlignment','center','VerticalAlignment', 'middle')    % center the second line
set(line3,'visible','on','HorizontalAlignment','center','VerticalAlignment', 'middle')    % center the third line
set(gcf,'color','w')    % set background color to white

pause   % wait for button press

%% Show instructions
set(line1,'String','Press ''y'' if you see a target and ''n'' if the target is absent');
set(line2,'String','Press a button to start the block');
delete(line3);

pause   % wait for button press
clf   % clear instructions

%% Define counters
% Create table with counters for the hit target 
dcol = zeros(4,1);   % fill column with zeros
dsym = zeros(4,1); % fill column with zeros
c = zeros(4,1); % fill column zeros
hitTable = table(dcol, dsym, c, 'RowNames', string(setSize)) % initialize the table with row- and columnnames

% Define counter variables
correctCounter = 0;
failCounter = 0;
i = 0;

%% Run practice trials and continue when 7/10 last trials are correct
while 1
    set(gcf, 'Name', 'Practice trial')   % show trial number in title
    text(0.5, 1, 'PRACTICE', 'FontSize', 14,'HorizontalAlignment','center');
    
    if i>10
        i = 0;  % reset trial counter to zero after every 10 trials
        correctCounter = 0;   % reset correct counter to zero after every 10 trials
    else
        i = i + 1;  % increase trial counter
    end
    
    %% Randomize target, condition and set size
    if rand>percentage  % if random number is above target probability, set no target
      target=0;
    else    % if below percentage, set target
      target=1;
    end
    
    % Randomize condition
    c = char(condition(randi(length(condition))));
    
    % Randomize set size
    n = setSize(randi(length(setSize)));
    
    %% Run experiment
    [RT, correct, buttonPress] = do_experiment(n, c, target);    % run experiment
    correctCounter = correctCounter + correct;  % increase correct counter
    
    %% Continue when at least 7/10 last trials correct 
    if correctCounter>=7   % break if 7/10 last trials are correct
        break
    end
end

clf   % clear pratice figure
line1 = text(0.5, 0.6, 'Well done! Press any button to continue to the actual experiment','HorizontalAlignment','center','VerticalAlignment','middle', 'FontSize', 14); % show instructions
set(gca,'visible','off','xlim',[0 1],'ylim',[0 1]); % remove the axis and set limits
pause
delete(line1);  % delete text

correctCounter = 0;     % set counter back to zero

%% Run experiment for given trials
for i = 1:trials
    set(gcf, 'Name', ['Trial:  ',num2str(i)])   % show trial number in title
    %% Randomize target, condition and set size
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
        
    % Stop trials if all 12 counters are at least 20
    if sum(hitTable{:,:} >= 20, 'all') >= 12
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

%% Show end-of-experiment message and save data
clf   % clear figure
line1 = text(0.5, 0.6, 'You''re all done with the experiment! Thanks for participating','HorizontalAlignment','center','VerticalAlignment','middle', 'FontSize', 14); % show end-of-experiment message
pause(3)    % pause 3 seconds before closing the figure
close    % close figure

% Save data participant in a .mat
save(['Data/run_experiment' num2str(studentID) '.mat'],'dataBlock')
 

