%   Title: Debortoli and Gali (2018) Testing
%   Objective: Code up the simple TA-New Keynesian model presented in Debortoli and Gali (2018)
%   Author: Nisha Chikhale
%   Date Created: 06/24/2020
%   Date Modified: 
% based on ECON810_ps1_q2.m
%%
clc;
clear;
%% Run Dynare 
%replication of model 
dynare tank_testing

%loop through various shocks one at a time for simulation
sd_e_nu_big = [0.25; 0; 0];
sd_e_z_big = [0; 0.5; 0];
sd_e_a_big = [0; 0; 1.0];
horizon = linspace(0,100,100);
L = {'Monetary Policy Shock'; 'Perference Shock'; 'Technology Shock'};
for i = 1:3
    sd_e_nu = sd_e_nu_big(i);
    sd_e_z = sd_e_z_big(i);
    sd_e_a = sd_e_a_big(i);
    save parameterfile sd_e_nu sd_e_z sd_e_a
    dynare tank_testingv1
    figure(100+i); 
    plot(horizon,oo_.endo_simul(1,1:100),'-');
    title(sprintf('%s', L{i}));
    xlabel('Quarters');
    ylabel('Output Gap'); %y_til
    
    figure(200+i); 
    k = 200+i;
    plot(horizon,oo_.endo_simul(4,1:100),'-');
    title(sprintf('%s', L{i}));
    xlabel('Quarters');
    ylabel('Output'); %y_hat
    saveas(figure(k),sprintf('FIG%d.png', k));
end


%add an uncertainty shock to the model
%replication of model w/ second moment shock to sig_a in which the std
%error of the shock is not known (no lagged sigma_a in AR1)
%dynare tank_testingv2
sd_e_nu = sd_e_nu_big(3);
sd_e_z = sd_e_z_big(3);
sd_e_a = sd_e_a_big(3);
save parameterfile sd_e_nu sd_e_z sd_e_a
dynare tank_testingv2


%% Plot commands
set(groot,'defaultLineLineWidth',2.0);
jj = linspace(0,40,40);
 figure(1);
 subplot(3,2,1);
 plot(jj,y_til_e_siga,'-');
 title('Output gap');
 xlabel('Quarters');
 ylabel('%-deviation');
 subplot(3,2,2);
 plot(jj,pi_e_siga,'-');
 title('Inflation');
 xlabel('Quarters');
 ylabel('%-deviation');
 subplot(3,2,3);
 plot(jj,i_hat_e_siga,'-');
 title('Interest rate');
 xlabel('Quarters');
 ylabel('%-deviation');
 subplot(3,2,4);
 plot(jj,y_hat_e_siga,'-');  
 title('Output');
 xlabel('Quarters');
 ylabel('%-deviation');
  subplot(3,2,5);
 plot(jj,sigma_a_e_siga,'-');
 title('Std dev of TFP');
 xlabel('Quarters');
 ylabel('%-deviation');
 saveas(figure(1),[pwd '/plots/fig1.png']), replace;

% horizon = linspace(0,100,100);
%  figure(1);
%   subplot(3,1,1);
%   plot(horizon,oo_.endo_simul(1,1:100),'-');
%   title('Monetary Policy Shock');
%   xlabel('Quarters');
%   ylabel('Output');
%   subplot(3,1,2);


%
%dynare tank_testingv3

