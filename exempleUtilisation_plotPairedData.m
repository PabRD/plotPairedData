% Exemple utilisation et possibilité de la fonction plotPairedData
clear
close all
clc

%% Création jeu de données
rng(13)
nbSujet = 25;                                                               % Combien de points dans chaque jeu de données
nbCond = 6;                                                                 % on compare 7 conditions differentes
mydata = arrayfun( @(x) normrnd(5*x,x,nbSujet,1), 1:nbCond, 'uni', 0 );
mydata = cell2mat(mydata);

%% Utilisation fonction et possibilité
% utilisation simple et rapide pour visualiser les données
f(1) = figure;
plotPairedData(mydata)                                                      % permet de plot uniquement ( ATTENTION, j'ai mis 6 couleurs donc il y aura erreur si plus de 6 conditions)
title('Sans aucun argument, plot rapide','Interpreter','latex')

%% Si plus de 6 conditions ou si vous n'aimez pas mes couleurs alors:
% col = cbrewer('seq','BuPu',9)
col =     [0.9686    0.9882    0.9922
    0.8784    0.9255    0.9569
    0.7490    0.8275    0.9020
    0.6196    0.7373    0.8549
    0.5490    0.5882    0.7765
    0.5490    0.4196    0.6941
    0.5333    0.2549    0.6157
    0.5059    0.0588    0.4863
    0.3020         0    0.2941];
col = flipud(col);

f(2) = figure;
plotPairedData(mydata,col(1:nbCond,:))                                      
title('Couleurs personalis\''ees','Interpreter','latex')

%%  modifier et ajuster en fonction des gouts et des couleurs
f(3) = figure;
[scatterHandle,lineHandle,scatterMeanHandle,errorbarHandle] = plotPairedData(mydata,col(1:nbCond,:));
title('Options comme mettre l''\''evolution moyenne','Interpreter','latex')
subtitle('Changer les marqueurs, les lignes, etc...','Interpreter','latex')

% les objects handles sont renvoyés grace à la "dot.notation" on peut modifier tous les éléments graphiques
% par exemple (liste non exhaustive):

% Simple:
scatterHandle.Marker = 'd';                                                 % je veux pas des cercles mais des diamants
scatterHandle.SizeData = 50;                                                % les données étaient trop grosses
scatterMeanHandle.SizeData = 50;                                            % les données étaient trop grosses
errorbarHandle.CapSize = 0;                                                 % ne pas afficher la petite barre en desosus?dessus des ecarts types
errorbarHandle.LineStyle = '-';                                             % afficher l'evolution moyenne

% plus technique (a ameliorer ducoup):
arrayfun(@(x) set(x,'linewidth',.5,'Color',...                              % les lignes sont stockées dans des cellules, je transforme en matrice puis j'applique a chaque élement de la matrice une fonction
    [0 0 0],'HandleVisibility','on'),[lineHandle{1}{:}])                    % la fonction set permet de modifier les parametres des ObjectHandle

set(errorbarHandle,'Color',col(4,:))

%% Fonctionne avec n'importe quel nombre d'échantillons
figure
plotPairedData(mydata(:,[3 6]))

% Si vous faites des améliorations sur la fonction je suis preneur :D
