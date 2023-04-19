function [scatterHandle,lineHandle,scatterMeanHandle,errorbarHandle] = plotPairedData(dataPlot,col)
% PLOTPAIREDDATA compares multiple dataset with raincloud plots.
%   plotPairedData(dataToPlotdataPlot) plot scatter data, mean+-SD
%   evolution, kernel densities, individual evolutions.
%
%   dataToPlot must be a n by m matrix with observations as rows and conditions as columns.
%
%   plotPairedData(dataToPlot,color) specifies the color you want. By
%   default color = [0.6000    0.4392    0.6706; 0.1059    0.4706    0.2157; 0.1294    0.4000    0.6745;0.8392    0.3765    0.3020;0.9922    0.6824    0.3804;0.8706    0.4667    0.6824];
%
%   [scatterHandle,lineHandle,scatterMeanHandle,errorbarHandle] =
%   plotPairedData(dataPlot,col) returns the object handle of scatter,
%   line, mean and errorbars so you can modify parameters with dot notation. For instance, you can change the MarkerSize of scatter
%   points with scatterHandle.SizeData = 50;
%   col=cbrewer('div','PRGn',11);
%
%   See also PLOT, LINE, SCATTER, KSDENSITY.
%   @PabDawan

switch nargin
    case 1
        nbColors = width(dataPlot);
        globalColor = [0.6000    0.4392    0.6706; 0.1059    0.4706    0.2157; 0.1294    0.4000    0.6745;0.8392    0.3765    0.3020;0.9922    0.6824    0.3804;0.8706    0.4667    0.6824];
        color = globalColor(1:nbColors,:);
    case 2
        color = col;
end

moy = mean(dataPlot);
ET = std(dataPlot);

nbSuj = height(dataPlot);
nbCondition = width(dataPlot);

x = repmat((1:nbCondition)+.18,nbSuj,1);
posX=reshape(x,1,[]).';
posY = reshape(dataPlot,1,[]).';

colScatter = repmat(reshape(color',1,[]),nbSuj,1);
colScatter = arrayfun(@(x) colScatter(:,x:x+2),1:3:width(colScatter)-2,'uni' ,0);
colScatter = cell2mat(colScatter');

ax=gca;                                            

scatterHandle = scatter( posX, ...                  
    posY, ...                        
    'filled','jitter','on','jitterAmount',0.08, ...                         
    'CData',colScatter,'MarkerFaceAlpha',0.3);                                   
scatterHandle.SizeData=100;                                                   
box on                                                                     


%% Line evolution
for nbGraphe = 2:nbCondition
    lineHandle{nbGraphe-1} = arrayfun(@(x) line([nbGraphe-1+ .28 nbGraphe-1+.72], ...
        dataPlot(x,nbGraphe-1:nbGraphe), ...
        'Color',[0 0 0 0.1],'HandleVisibility','off','LineWidth',1.5),1:nbSuj,'uni',0);

end
%% patch violin
%Bowman & Azzalini. Applied Smoothing Techniques for Data Analysis, 1997.

% Set up a figure with as many subplots as you have data categories
% data has to be {data1} {data2} ... {dataEnd}

data_violin=mat2cell(dataPlot',ones(1,nbCondition)).';
palette = parula( numel(data_violin) ); % What palette will you use for the violins?

[f,xi,p] = deal({},{},{});
band_width=[];

for i = 1:numel(data_violin)
    x = data_violin{i};
    %[f{i},xi{i},u{i}] = ksdensity( x, linspace( prctile(x,1),prctile(x,99), 100));
    [f{i},xi{i}] = ksdensity( x, 'Bandwidth',band_width);
    f{i}=f{i}/max(f{i})*.26;
    p{i}=patch( 0-[f{i},zeros(1,numel(xi{i}),1),0]+i,[xi{i},fliplr(xi{i}),xi{i}(1)],palette(i,:));

end
patches=findobj(gcf,'Type','Patch');

arrayfun(@(x,y) set(x,'FaceAlpha',0.5,'FaceColor',color(y,:),'EdgeColor',color(y,:),'EdgeAlpha',0.5,'HandleVisibility','off'),patches,flipud(transpose(1:nbCondition)))
hold on

ax.XLim=[0.5 nbCondition+.5];
%% MEAN + SD

errorbarHandle=errorbar(moy,ET,'CapSize',5,'Color',"k","LineStyle","none");        % Tracer l'ET en noir sans les barres horisontales
errorbarHandle.HandleVisibility="off";                                            % Servira à ne pas l'afficher dans la légende
errorbarHandle.LineWidth=1.5;                                                       % Epaisseur de ligne


scatterMeanHandle=scatter(1:width(dataPlot),moy,'filled','CData',color);     % Point moyen
scatterMeanHandle.HandleVisibility="off";
scatterMeanHandle.SizeData=100;
scatterMeanHandle.MarkerEdgeColor='k';
scatterMeanHandle.LineWidth=1.5;

ax.XTick=1:width(dataPlot);  
hfig= gcf;             
picturewidth = 20;                                                     
hw_ratio = 0.65;                                                     
set(findall(hfig,'-property','FontSize'),'FontSize',17)             
set(findall(hfig,'-property','Box'),'Box','on')                   
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex')
ax.Title.Interpreter="latex";
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth])
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

end