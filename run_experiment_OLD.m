% This is the script for running the Treisman Visual Search experiment

% % Prompt for studentnumber, trials and percentage
% % prompt = {'Studentnumber participant:','Number of trials', 'Percentage'};
% % dlgtitle = 'Input';
% % answer = inputdlg(prompt,dlgtitle)

% questdlg("Start Experiment", "TITLE", 'No')   % start button to start
% experiment

%% Initialize data block
studentID = 1089030;
trials = 100;
condition = {'dcol', 'dsym', 'c'};
setSize = [8 24 40 56];
dataBlock = struct.empty(600,0);  % pre-allocate struct for trial data
breaks = struct.empty(8,0);   % pre-allocate struct breaks in experiment

% data(35) = struct('reactiontime', [], 'condition', [], 'trial', []);


studentID = 1089030;
percentage = 0.8;

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

%% Create counters for the hit-trial
c8 = 0;
c24 = 0;
c40 = 0;
c56  = 0;
dcol8 = 0;
dcol24 = 0;
dcol40 = 0;
dcol56  = 0;
dsym8 = 0;
dsym24 = 0;
dsym40 = 0;
dsym56  = 0;

%% Run experiment

% Run experiment until 20 trials with target have been correct
for i = 1:trials    
    % Determine if there's a target
    if rand>percentage  % if random number is above percentage, set no target
      target=0;
    else    % if below percentage, set target
      target=1;
    end
    
    % Randomize condition
    c = char(condition(randi(length(condition))));
    
    % Randomize set size
    n = setSize(randi(length(setSize)));
    
    dataBlock(i).ppn = studentID;   % register partipant
    dataBlock(i).trial = i; % register trial
    dataBlock(i).condition = c; % register condition
    dataBlock(i).setSize = n;   % register set size
    dataBlock(i).target = target;   % register target
    [dataBlock(i).RT, dataBlock(i).correct, dataBlock(i).buttonPress] = do_experiment(n, c, target); % register reactiontime, correct and button pressed    
    
%     a = [dataBlock(:).target] == 1    
    
    if target == 1 && dataBlock(i).correct == 1
        if strcmp(c, 'dcol')
            if n == 8
                dcol8 = dcol8 + 1;
            elseif n == 24
                dcol24 = dcol24 + 1;
            elseif n == 40
                dcol40 = dcol40 + 1;
            else 
                dcol56  = dcol56 + 1;
            end    
        elseif strcmp(c, 'dsym')
            if n == 8
                dsym8 = dsym8 + 1;
            elseif n == 24
                dsym24 = dsym24 + 1;
            elseif n == 40
                dsym40 = dsym40 + 1;
            else 
                dsym56 = dsym56 + 1;
            end 
        else
            if n == 8
                c8 = c8 + 1;
            elseif n == 24
                c4 = c24 + 1;
            elseif n == 40
                c40 = c40 + 1;
            else 
                c56  = c56 + 1;
        end
        end  
    end
    
    % If all counters are 20 or higher, stop trials
    if c8>1 && c24>1 && c40>1 && c56>1 && dcol8>1 && dcol24>1 && dcol40>1 && dcol56>1 && dsym8>1 && dsym24>1 && dsym40>1 && dsym56>1
        disp("ALLES 2")
        break
    end
    
    % Give the user a break after every 75 trials
    if mod(i,8) == 0
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
%  save('run_experiment','dataBlock');
 save(['run_experiment' num2str(studentID) '.mat'],'dataBlock')
 

