function Treisman_exp(n, cond, target)
% uitleg
%
%

%% Check function input
% Check if n is an integer and larger than 0
if mod(n,1)~=0 || n<1
    error('n is not a number bigger than 0');
end
% Check is condition is a string
if ~ischar(cond)
    error('Condition input not a string');
end
% Check if target is 0 or 1
if target~=0 && target~=1
    error('Target has to be 0 or 1');
end

%% Create table with for the distributions
targetColor = zeros(2,1);   % fill column with zeros
distColor = zeros(2,1); % fill column with zeros
taskTable = table(targetColor, distColor, 'RowNames', {'targetSymbol','distSymbol'}); % initialize table with row- and columnnames

%% Assign colors and symbols to target and distractors randomly
if randi(2) == 1    % pick randomly 1 or 2 to decide target color
    targetColor = 'r';
    distColor = 'b';
else
    targetColor = 'b';
    distColor = 'r';
end
if randi(2) == 1    % pick randomly 1 or 2 to decide target symbol 
    targetSymbol = 'o';
    distSymbol = 'x';
else
    targetSymbol = 'x';
    distSymbol = 'o';
end   

%% Distribute amounts per stimuli
switch cond
    case 'dcol' % set distributions in case of distinctive color search
        taskTable{'targetSymbol','targetColor'} = target;   % assign target
        if mod(n,2) ~= 0    % If not divisible by two round amounts so there's only integers
            taskTable{'targetSymbol','distColor'} = floor((n/2) - target);  % Round down
            taskTable{'distSymbol','distColor'} = ceil(n/2);    % Round up
        else
            taskTable{'targetSymbol','distColor'} = (n/2) - target;
            taskTable{'distSymbol','distColor'} = n/2;
        end
        taskTable{'distSymbol','targetColor'} = 0;  % assign target
    case 'dsym' % set distributions in case of distinctive symbol search
        taskTable{'targetSymbol','targetColor'} = target;
        taskTable{'targetSymbol','distColor'} = 0;
        if mod(n,2) ~= 0    % If not divisible by two round amounts so there's only integers
            taskTable{'distSymbol','distColor'} = floor(n/2);
            taskTable{'distSymbol','targetColor'} = ceil((n/2) - target);    
        else
            taskTable{'distSymbol','distColor'} = n/2;
            taskTable{'distSymbol','targetColor'} = (n/2) - target;   
        end       
    case 'c' % set distributions in case of conjunctive search
        taskTable{'targetSymbol','targetColor'} = target; % assign target
        if mod(n,4) == 1 || mod(n,4) == 2   % If the modulo of 4 is 1 or 2, round amounts so there's only integers
            taskTable{'targetSymbol','distColor'} = floor(n/4);
            taskTable{'distSymbol','distColor'} = floor(n/4);
            taskTable{'distSymbol','targetColor'} = ceil((n/2) - target);
        elseif mod(n,4) == 3    % If the modulo of 4 3, round amounts so there's only integers
            taskTable{'targetSymbol','distColor'} = floor(n/4);
            taskTable{'distSymbol','distColor'} = ceil(n/4);
            taskTable{'distSymbol','targetColor'} = ceil((n/2) - target);
        else
            taskTable{'targetSymbol','distColor'} = n/4;
            taskTable{'distSymbol','distColor'} = n/4;
            taskTable{'distSymbol','targetColor'} = (n/2) - target;
        end        
end

%% Put stimuli in figure
set(gca,'visible','off','xlim',[0 1],'ylim',[0 1]); % hide axis and set limits
 
% Check if there are target symbol and distractor color combination-s
if taskTable{'targetSymbol','distColor'}>0
    for i = 1:taskTable{'targetSymbol','distColor'} % Place the target symbol and distractor color combination-s in figure
        put_symbol_inFigure(rand(1,2),targetSymbol,distColor);
        set(gcf, 'Visible', 'off');  % hide figure
        hold on
    end
end
% Check if there are target symbol and distractor color combination-s
if taskTable{'distSymbol','distColor'}>0
    for i = 1:taskTable{'distSymbol','distColor'}   % Place the distractor symbol and distractor color combination-s in figur
        put_symbol_inFigure(rand(1,2),distSymbol,distColor);
        set(gcf, 'Visible', 'off');  % hide figure
        hold on
    end
end
% Check if there are target symbol and distractor color combination-s
if taskTable{'distSymbol','targetColor'}>0
    for i = 1:taskTable{'distSymbol','targetColor'} % Place the distractor symbol distractor color combination-s in figure
        put_symbol_inFigure(rand(1,2),distSymbol,targetColor);
        set(gcf, 'Visible', 'off');  % hide figure
        hold on
    end
end
% Check if there's a target
if target
    put_symbol_inFigure(rand(1,2),targetSymbol,targetColor);    % Place target in figure
    set(gcf, 'Visible', 'off');  % hide figure
end
hold off
end

