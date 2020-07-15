% Title: Plots from Interacted VAR 
% Objective: Create subplots from I-VAR for presentatioin slides
% Author: Nisha Chikhale
% Date Created: 05/18/2020
% Date Modified: 05/19/2020
%% Based on VARirplot_2New_CCP.m and VARtestplot_2New_CCP.m from Caggiano et al. (2017) replication files
%% 
clc;
clear;
addpath '/Users/nishachikhale/Documents/MATLAB/ECON718/StateDependenceofAggUncertainty/code/caggianoetal2017_data_and_replication_codes/I-VAR tbx_/utils by A. Cesa Bianchi'
addpath '/Users/nishachikhale/Documents/MATLAB/ECON718/StateDependenceofAggUncertainty/code/caggianoetal2017_data_and_replication_codes/I-VAR tbx_/utils for figures'
load('ivar_v5.mat');
FontSize = 16;
%% GIRFs from figure 1 %% 
%% Check optional inputs & Define some parameters
%================================================
if ~exist('filename','var') 
    filename = 'shock_';
end

if ~exist('FontSize','var') 
    FontSize = 16;
end

% Define inputs
IRFmed1 = OIRF2avg;
IRFmed2 = OIRFavg;
INF1 = INFavgH2;
SUP1 = SUPavgH2;
INF2 = INFavgL2;
SUP2 = SUPavgL2;

% Initialize IRF matrix
[nsteps, nvars, nshocks] = size(IRFmed1);

% If one shock is chosen, set the right value for nshocks
if ~exist('pick','var') 
    pick = 1;
else
    if pick<0 || pick>nvars
        error('The selected shock is non valid')
    else
        if pick==0
            pick=1;
        else
            nshocks = pick;
        end
    end
end

% Define the rows and columns for the subplots
row = round(sqrt(nvars));
col = ceil(sqrt(nvars));

% Define a timeline
steps = 1:1:nsteps;
x_axis = zeros(1,nsteps);

%% Plot
%=========
% FigSize(24,8)
for jj = pick:nshocks                
    for ii=1:nvars
         figure(ii)
         cla;
      %  subplot(col,row,ii);
      %  set(gca,'XTick',[5 10 15 20])

         if exist('INF1','var') && exist('SUP1','var')
%             plot(steps,INF1(:,ii,jj),'LineStyle','-','Color',rgb('light blue'),'LineWidth',1);
%             hold on
%             plot(steps,SUP1(:,ii,jj),'LineStyle','-','Color',rgb('light blue'),'LineWidth',1);
 
      plot1=shadedplot(steps,INF1(:,ii,jj)',SUP1(:,ii,jj)',[0.7 0.7 0.7],[0.7 0.7 0.7] );
      set(gca,'XTickLabelMode', 'manual','XTickLabel',{'5','10','15','20'},'XTick',[5 10 15 20])
% grpyat=[steps', INF1(:,ii,jj); (nsteps:-1:1)' SUP1(:,ii,jj)];
% plot1=patch(grpyat(:,1), grpyat(:,2), [0.8 0.8 0.8],'edgecolor', [0.8 0.8 0.8]);
%          hAnnotation = get(plot1,'Annotation');
%         hLegendEntry = get(hAnnotation','LegendInformation');
%        set(hLegendEntry,'IconDisplayStyle','off')
hold on
          plot1=plot(steps,INF1(:,ii,jj),'LineStyle','-','Color',rgb('dark blue'),'LineWidth',1);
        hAnnotation = get(plot1,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off')
            hold on
            plot1=plot(steps,SUP1(:,ii,jj),'LineStyle','-','Color',rgb('dark blue'),'LineWidth',1);
         hAnnotation = get(plot1,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off')

       
         hold on
          plot1=plot(steps,INF2(:,ii,jj),'LineStyle','-','Color',rgb('red'),'LineWidth',1.5);
        hAnnotation = get(plot1,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off')
            hold on
            plot1=plot(steps,SUP2(:,ii,jj),'LineStyle','-','Color',rgb('red'),'LineWidth',1.5);
         hAnnotation = get(plot1,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off')
         end
        hold on
        plot1=plot(x_axis,'k','LineWidth',0.5);
        hAnnotation = get(plot1,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off')
        
        hold on 
        p2=plot(steps,IRFmed1(:,ii,jj),'LineStyle','-','Color',rgb('dark blue'),'LineWidth',2.5);
        hold on
        p3=plot(steps,IRFmed2(:,ii,jj),'LineStyle','--','Color',rgb('red'),'LineWidth',2.5);
       
        xlim([1 nsteps]);
     
        if exist('labels','var') 
            title(labels(ii),'FontSize',16); 
        end
            ax.FontSize = 17;
         xlabel('Time in quarters');
         if (ii >2 && ii<7)
         ylabel('%-deviation');
         else
         ylabel('Deviation in levels');  
         end
%         ylabel('Place your label here');
         FigFont(FontSize);
%legend([p2 p3],{'Normal times','ZLB'});  
legend([p2 p3],{'High ineq.','Low ineq.'},'Location','best');  
% close all

     set(gcf, 'Color', 'w');
     saveas(figure(ii),sprintf('/Users/nishachikhale/Documents/MATLAB/ECON718/StateDependenceofAggUncertainty/code/plots/ivar/v5plots_fig%d.png',ii));

    end
    if exist('labels','var')
       %  SupTitle( ['GIRF - Shock to ' char(labels(jj)) ' equation '] ); %. solid blue:low uncertainty , dashed red:high uncertainty ' 
    end
end
 
% without confidence bands
for jj = pick:nshocks                
    for ii=1:nvars
         figure(ii)
         cla;
      %  subplot(col,row,ii);
      %  set(gca,'XTick',[5 10 15 20])

%         if exist('INF1','var') && exist('SUP1','var')
%             plot(steps,INF1(:,ii,jj),'LineStyle','-','Color',rgb('light blue'),'LineWidth',1);
%             hold on
%             plot(steps,SUP1(:,ii,jj),'LineStyle','-','Color',rgb('light blue'),'LineWidth',1);
 
%      plot1=shadedplot(steps,INF1(:,ii,jj)',SUP1(:,ii,jj)',[0.7 0.7 0.7],[0.7 0.7 0.7] );
      set(gca,'XTickLabelMode', 'manual','XTickLabel',{'5','10','15','20'},'XTick',[5 10 15 20])
% grpyat=[steps', INF1(:,ii,jj); (nsteps:-1:1)' SUP1(:,ii,jj)];
% plot1=patch(grpyat(:,1), grpyat(:,2), [0.8 0.8 0.8],'edgecolor', [0.8 0.8 0.8]);
%          hAnnotation = get(plot1,'Annotation');
%         hLegendEntry = get(hAnnotation','LegendInformation');
%        set(hLegendEntry,'IconDisplayStyle','off')
%hold on
%           plot1=plot(steps,INF1(:,ii,jj),'LineStyle','-','Color',rgb('dark blue'),'LineWidth',1);
%         hAnnotation = get(plot1,'Annotation');
%         hLegendEntry = get(hAnnotation','LegendInformation');
%         set(hLegendEntry,'IconDisplayStyle','off')
%             hold on
%             plot1=plot(steps,SUP1(:,ii,jj),'LineStyle','-','Color',rgb('dark blue'),'LineWidth',1);
%          hAnnotation = get(plot1,'Annotation');
%         hLegendEntry = get(hAnnotation','LegendInformation');
%         set(hLegendEntry,'IconDisplayStyle','off')
% 
%        
%          hold on
%           plot1=plot(steps,INF2(:,ii,jj),'LineStyle','-','Color',rgb('red'),'LineWidth',1.5);
%         hAnnotation = get(plot1,'Annotation');
%         hLegendEntry = get(hAnnotation','LegendInformation');
%         set(hLegendEntry,'IconDisplayStyle','off')
%             hold on
%             plot1=plot(steps,SUP2(:,ii,jj),'LineStyle','-','Color',rgb('red'),'LineWidth',1.5);
%          hAnnotation = get(plot1,'Annotation');
%         hLegendEntry = get(hAnnotation','LegendInformation');
%         set(hLegendEntry,'IconDisplayStyle','off')
%          end
%        hold on
        plot1=plot(x_axis,'k','LineWidth',0.5);
        hAnnotation = get(plot1,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off')
        
        hold on 
        p2=plot(steps,IRFmed1(:,ii,jj),'LineStyle','-','Color',rgb('dark blue'),'LineWidth',2.5);
        hold on
        p3=plot(steps,IRFmed2(:,ii,jj),'LineStyle','--','Color',rgb('red'),'LineWidth',2.5);
       
        xlim([1 nsteps]);
        if exist('labels','var') 
            title(labels(ii),'FontSize',16); 
        end
%         xlabel('Place your label here');
%         ylabel('Place your label here');
         FigFont(FontSize);
%legend([p2 p3],{'Normal times','ZLB'});  
legend([p2 p3],{'High ineq.','Low ineq.'},'Location','best');  
% close all

     set(gcf, 'Color', 'w');
     saveas(figure(ii),sprintf('/Users/nishachikhale/Documents/MATLAB/ECON718/StateDependenceofAggUncertainty/code/plots/ivar/v5_avg_fig%d.png',ii));

    end
    if exist('labels','var')
       %  SupTitle( ['GIRF - Shock to ' char(labels(jj)) ' equation '] ); %. solid blue:low uncertainty , dashed red:high uncertainty ' 
    end
end




%% GIRFs from figure 2 %% 
% Define new inputs
IRFmed1 = dOIRFavg;
IRFmed2 = dOIRFavg;
INF1 = dIRFinf2;
SUP1 = dIRFsup2;
INF2 = dIRFinf2;
SUP2 = dIRFsup2;
%% Plot
%=========
% FigSize(24,8)
             
    for ii=1:nvars
         figure(ii)
         cla;
        %subplot(col,row,ii);
          if exist('INF1','var') && exist('SUP1','var')
          
             shadedplot(steps,INF2(:,ii)',SUP2(:,ii)',[0.9 0.9 0.9],[0.9 0.9 0.9] );
             hold on
             plot(steps,INF2(:,ii),'LineStyle',':','Color',rgb('black'),'LineWidth',1);
            hold on
             plot(steps,SUP2(:,ii),'LineStyle',':','Color',rgb('black'),'LineWidth',1);           
             
             hold on
%             plot(steps,INF1(:,ii),'LineStyle','-','Color',rgb('light blue'),'LineWidth',1);
%             hold on
%             plot(steps,SUP1(:,ii),'LineStyle','-','Color',rgb('light blue'),'LineWidth',1);
            shadedplot(steps,INF1(:,ii)',SUP1(:,ii)',[0.7 0.7 0.7],[0.7 0.7 0.7] );
            hold on 
          end       
        
        plot(steps,IRFmed1(:,ii),'LineStyle','-','Color',rgb('black'),'LineWidth',1.5);
        hold on
        plot(steps,IRFmed2(:,ii),'LineStyle','-','Color',rgb('black'),'LineWidth',1.5);
          hold on
          if exist('INF2','var') && exist('SUP2','var')
              plot(steps,INF2(:,ii),'LineStyle','-','Color',rgb('dark blue'),'LineWidth',1);
              hold on
              plot(steps,SUP2(:,ii),'LineStyle','-','Color',rgb('dark blue'),'LineWidth',1);
              hold on
          end
        plot(x_axis,'k','LineWidth',0.5)

        xlim([1 nsteps]);
        if exist('labels','var') 
            title(labels(ii),'FontSize',FontSize); 
        end
        legend('off')
        ax.FontSize = 17;
         xlabel('Time in quarters');
         if (ii >2 && ii<7)
         ylabel('Difference in %-deviation (p.p.)');
         else
         ylabel('Difference in levels');  
         end
         FigFont(FontSize);
       set(gca,'XTickLabelMode', 'manual','XTickLabel',{'5','10','15','20'},'XTick',[5 10 15 20])
       set(gcf, 'Color', 'w');
     saveas(figure(ii),sprintf('/Users/nishachikhale/Documents/MATLAB/ECON718/StateDependenceofAggUncertainty/code/plots/ivar/v5plots_diff_fig%d.png',ii));

    end
     if exist('labels','var')
       end

%     % Save
%     set(gcf, 'Color', 'w');
%     FigName = [filename num2str(jj)];
%     export_fig(FigName,'-pdf','-png','-painters')
%     clf('reset');


% close all














