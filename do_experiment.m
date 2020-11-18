function [reactionTime, correct, buttonPress] = do_experiment(n, cond, target)
% description of the function

%% Create figure using n, the condition and whether there's a target
Treisman_exp(n, cond, target)

%% Measure reaction time. Make use of tic-toc and pause. Remember that
tic     % start timer
set(gcf, 'Visible', 'on');  % show figure just after timer started

pause

reactionTime = toc; % end timer after button press

%% Error check for correct buttons
buttonPress = get(gcf, 'CurrentCharacter');   % store buttonpress
if strcmpi(buttonPress,'y') || strcmpi(buttonPress,'n') % check if either button 'y' or 'n' has been pressed
else
    uiwait(warndlg("Please make sure that your fingers are on the y and n button")); % give a warning if pressed a wrong button
end

%% Check whether response is correct or not
% Check if there's a target
if target == 1 && strcmp(buttonPress,'y')    % if there's a target and participant presses yes, correct
    correct = 1;
elseif target == 0 && strcmp(buttonPress,'n')    % if there's no target and participant presses no, correct
    correct = 1;
else    % incorrect if otherwise
    correct = 0; 
end
% Close the current figure
clf

end