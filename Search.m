function Search_w3 (n, search)

if search == 1
    blueX = n/2;
    blueO = n/2;
    redX = 0;
    redO = 0;
    target = 1;
    figName = 'Symbol';
elseif search == 2
    blueX = 
    blueO =
    redX = 
    redO = 
    target = 
    figName = 'Colour';
else
    blueX =
    blueO =
    redX = 
    redO = 
    target = 
end

fig3 = figure('Name','Conjunctive');

for i = 1:blueCross
    put_symbol_inFigure(rand(1,2),'x','b');
    hold on
end
for i = 1:blueCircle
    put_symbol_inFigure(rand(1,2),'o','b');
    hold on
end
for i = 1:redCircle
    put_symbol_inFigure(rand(1,2),'o','r');
    hold on
end
for i = 1:target
    put_symbol_inFigure(rand(1,2),'x','r');
    hold on
end
hold off


    

end
