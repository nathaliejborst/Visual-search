participant = load('run_experimentNaN.mat').dataBlock

cond = [participant.condition]
% cell2mat(cond)
% RT = [participant.RT]
% BP = [participant.buttonPress]
g = cond == 'c'
cond(g)