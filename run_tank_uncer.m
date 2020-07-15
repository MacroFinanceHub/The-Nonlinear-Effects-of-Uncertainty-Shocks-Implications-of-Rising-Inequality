%   Title: Debortoli and Gali (2018) with Uncertainty Testing
%   Objective: Code up the simple TA-New Keynesian model presented in Debortoli and Gali (2018)
%   Author: Nisha Chikhale
%   Date Created: 06/24/2020
%   Date Modified: 07/09/20
% based on ECON810_ps1_q2.m
%%
clc;
clear;

%Parameter values
sd_e_nu_big = [0.25; 0; 0];
sd_e_z_big = [0; 0.5; 0];
sd_e_a_big = [0; 0; 1.0];
sd_e_signu_big = [0.140; 0; 0];
%sd_e_sigz_big = [0; 0.140; 0];
sd_e_sigz_big = [0; 0.2; 0];
sd_e_siga_big = [0; 0; 0.140];

%% Select model with only technology shocks and an uncertainty shock to technology a only:
%  sd_e_nu = sd_e_nu_big(3);
%  sd_e_z = sd_e_z_big(3);
%  sd_e_a = sd_e_a_big(3);
%  save parameterfile sd_e_nu sd_e_z sd_e_a
%  dynare tank_testingv2

% v2 adds only second moment shock to technology and explores why the IRFs
% to an uncertainty shock are not smooth (due to sigma_a's AR1 process depending on the lagged realizations of sigma_a)
% see run_tank_testing.m

%% Select model with first moment shocks and uncertainty shock to preferences z and economic policy rate nu:
%format figures
jj = linspace(0,40,40);
% set(groot,'defaultLineLineWidth',1.5);
% FontSize=17;
set(groot,'defaultLineLineWidth',2.0);
FontSize=19;


 for i = 1:2
     sd_e_nu = sd_e_nu_big(i);
     sd_e_z = sd_e_z_big(i);
     sd_e_a = sd_e_a_big(i);
     sd_e_signu = sd_e_signu_big(i);
     sd_e_sigz = sd_e_sigz_big(i);
     sd_e_siga = sd_e_siga_big(i);
     save parameterfile sd_e_nu sd_e_z sd_e_a sd_e_siga sd_e_sigz sd_e_signu
     dynare tank_testingv3
     
     if i == 1 
     figure(i);
     subplot(3,2,1);
    plot(jj,y_til_e_signu,'-');
    title('Output gap');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,2);
    plot(jj,pi_e_signu,'-');
    title('Inflation');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,3);
    plot(jj,i_hat_e_signu,'-');
    title('Interest rate');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,4);
    plot(jj,y_hat_e_signu,'-');  
    title('Output');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,5);
    plot(jj,sigma_nu_e_signu,'-');
    title('Std dev of nu');
    xlabel('Quarters');
    ylabel('%-deviation');
    saveas(figure(i),[pwd '/plots/fig1_v3.png']);
     elseif i == 2
      figure(i);
     subplot(3,2,1);
    plot(jj,y_til_e_sigz,'-');
    title('Output gap');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,2);
    plot(jj,pi_e_sigz,'-');
    title('Inflation');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,3);
    plot(jj,i_hat_e_sigz,'-');
    title('Interest rate');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,4);
    plot(jj,y_hat_e_sigz,'-');  
    title('Output');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,5);
    plot(jj,sigma_z_e_sigz,'-');
    title('Std dev of z');
    xlabel('Quarters');
    ylabel('%-deviation');
    saveas(figure(i),[pwd '/plots/fig2_v3.png']) ;
     end

 end

% v3 trys to explore other second moment shocks that can generate different
% types of uncertainty: these alternatives produce different IRFS naturally

% pref uncertainty: output (y_hat) and inflation both fall in response to
% uncertainty and then tend back to zero jaggedly having these variables
% fall together resembles the response to a negative demand shock.


%% Introduce inequality states
%lambda_big = [0.21;; 0.44; 0.66; 0.9];
lambda_big = [0.11; 0.21; 0.36];
nl = length(lambda_big);
psi_a_big = [0.5; 1.0; 2.0];
np = length(psi_a_big);
C_ratio = zeros(nl,np);
res_c_hat = zeros(40,nl);
res_y_hat = zeros(40,nl);
res_pi = zeros(40,nl);
res_i_hat = zeros(40,nl);
IRF = zeros(40,6,nl);


%loop through various levels of 'ineqaullity' by increasing the fractions
%of constrained/hand to mouth households

for i = 1:nl
   % k = i; %no difference as k = 2, changing k = 1,2,3 doesnt change the
    %irfs either
    k = 2 ;%for psi_a = 1.0
    j = 2 ;%for a preference shock
    sd_e_nu = sd_e_nu_big(j);
    sd_e_z = sd_e_z_big(j);
    sd_e_a = sd_e_a_big(j);
    sd_e_signu = sd_e_signu_big(j);
    sd_e_sigz = sd_e_sigz_big(j);
    sd_e_siga = sd_e_siga_big(j);
    lambda = lambda_big(i);
    %psi_a = psi_a_big(k/i); holding psi_a constant and varying it along with
    %lambda both give the same magnitude IRFs. why?
   
    psi_a = psi_a_big(k);
    save parameterfile sd_e_nu sd_e_z sd_e_a sd_e_siga sd_e_sigz sd_e_signu lambda psi_a
    dynare tank_techunc 
    C_ratio(i,k) = 1 - gamma;
    
    res_c_hat(:,i) = c_hat_e_sigz(:,1);
    res_y_hat(:,i) = y_hat_e_sigz(:,1);
    res_pi(:,i) = pi_e_sigz(:,1);
    res_i_hat(:,i) = i_hat_e_sigz(:,1);
    
    figure(10+i);
    subplot(3,2,1);
    plot(jj,y_til_e_sigz,'-');
    title('Output gap');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,2);
    plot(jj,pi_e_sigz,'-');
    title('Inflation');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,3);
    plot(jj,i_hat_e_sigz,'-');
    title('Interest rate');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,4);
    plot(jj,y_hat_e_sigz,'-');  
    title('Output');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,5);
    plot(jj,sigma_z_e_sigz,'-');
    title('Std dev of z');
    xlabel('Quarters');
    ylabel('%-deviation');
    subplot(3,2,6);
    plot(jj,gamma_hat_e_sigz,'-');
    title('Inequality index');
    xlabel('Quarters');
    ylabel('%-deviation');
    saveas(figure(10+i),sprintf('/Users/nishachikhale/Documents/MATLAB/ECON718/StateDependenceofAggUncertainty/code/DebortoliGali/plots/uncrirf_%d.png', i)) ;
    
    IRF(:,1,i) = y_til_e_sigz(:,1);
    IRF(:,2,i) = pi_e_sigz(:,1);
    IRF(:,3,i) = i_hat_e_sigz(:,1);
    IRF(:,4,i) = y_hat_e_sigz(:,1); %also consumption
    IRF(:,5,i) = sigma_z_e_sigz(:,1);
    IRF(:,6,i) = gamma_hat_e_sigz;
    
    
end


diff_c31(:,1) = res_c_hat(:,3)- res_c_hat(:,1);
diff_y31(:,1) = res_y_hat(:,3)- res_y_hat(:,1);
diff_pi31(:,1) = res_pi(:,3)- res_pi(:,1);
diff_i31(:,1) = res_i_hat(:,3)- res_i_hat(:,1);

% diff_c41(:,1) = res_c_hat(:,4)- res_c_hat(:,1);
% diff_y41(:,1) = res_y_hat(:,4)- res_y_hat(:,1);
% diff_pi41(:,1) = res_pi(:,4)- res_pi(:,1);
% diff_i41(:,1) = res_i_hat(:,4)- res_i_hat(:,1);

%smooth differences
ds_c31(1,1) = diff_c31(1,1);
ds_c31(12,1) = diff_c31(12,1);
ds_y31(1,1) = diff_y31(1,1);
ds_y31(12,1) = diff_y31(12,1);
ds_pi31(1,1) = diff_pi31(1,1);
ds_pi31(12,1) = diff_pi31(12,1);
ds_i31(1,1) = diff_i31(1,1);
ds_i31(12,1) = diff_i31(12,1);


for i = 2:12-1
    ds_c31(i,1) = sum(ds_c31(i-1:i+1,1))/3;
    ds_y31(i,1) = sum(ds_y31(i-1:i+1,1))/3;
    ds_pi31(i,1) = sum(ds_pi31(i-1:i+1,1))/3;
    ds_i31(i,1) = sum(ds_i31(i-1:i+1,1))/3;
end
% the smoothed differences are 0 for first 10 quarters then begin to increase
    


%Low to High Inequality

 figure(3);
 clc;
 plot(jj(1,1:12),diff_c31(1:12,1),'-');
 title('Consumption gap');
 xlabel('Time in Quarters');
 ylabel('Difference in responses (deviation)');
% ylim([-1e-04 2e-04]);
 line = refline(0,0);
 line.Color = 'k';
 line.LineWidth = 1.0;
% %ylabel('%-deviation');
 saveas(figure(3),[pwd '/plots/diffc_uncr.png'])

figure(4);
clc;
plot(jj(1,1:12),diff_y31(1:12,1),'-');
title('Output gap');
xlabel('Time in Quarters');
ylabel('Difference in responses (%-deviation)');
%ylim([-1e-04 2e-04]);
line = refline(0,0);
line.Color = 'k';
line.LineWidth = 1.0;
%ylabel('%-deviation');
saveas(figure(4),[pwd '/plots/diffy_uncr.png'])


 figure(5);
 clc;
 plot(jj(1,1:12),diff_pi31(1:12,1),'-');
 title('Inflation');
 xlabel('Time in Quarters');
 ylabel('Difference in responses (deviation)');
% ylim([-2e-05 6.5e-05]);
 line = refline(0,0);
 line.Color = 'k';
 line.LineWidth = 1.0;
% %ylabel('%-deviation');
 saveas(figure(5),[pwd '/plots/diffpi_uncr.png'])

figure(6);
clc;
plot(jj(1,1:12),diff_i31(1:12,1),'-');
title('Interest rate gap');
xlabel('Time in Quarters');
ylabel('Difference in responses (deviation)');
%ylim([-3e-05 9e-05]);
line = refline(0,0);
line.Color = 'k';
line.LineWidth = 1.0;
%ylabel('%-deviation');
saveas(figure(6),[pwd '/plots/diffi_uncr.png'])

% Appendix Figs
 figure(7);
 clc;
 subplot(3,2,1);
 plot(jj(1,1:12),IRF(1:12,1,1),'--r');
 hold on 
 plot(jj(1,1:12),IRF(1:12,1,3),'-b');
 title('Output gap');
 xlabel('Quarters');
 ylabel('deviation');
 subplot(3,2,2);
 plot(jj(1,1:12),IRF(1:12,2,1),'--r');
 hold on 
 plot(jj(1,1:12),IRF(1:12,2,3),'-b');
 title('Inflation');
 xlabel('Quarters');
 ylabel('deviation');
 subplot(3,2,3);
 plot(jj(1,1:12),IRF(1:12,3,1),'--r');
 hold on 
 plot(jj(1,1:12),IRF(1:12,3,3),'-b');
 title('Interest rate');
 xlabel('Quarters');
 ylabel('deviation');
 subplot(3,2,4);
 plot(jj(1,1:12),IRF(1:12,4,1),'--r');
 hold on 
 plot(jj(1,1:12),IRF(1:12,4,3),'-b'); 
 title('Output');
 xlabel('Quarters');
 ylabel('deviation');
 subplot(3,2,5);
 plot(jj(1,1:12),IRF(1:12,5,1),'--r');
 hold on 
 plot(jj(1,1:12),IRF(1:12,5,3),'-b'); 
 title('Std dev of z');
 xlabel('Quarters');
 ylabel('deviation');
 subplot(3,2,6);
 plot(jj(1,1:12),IRF(1:12,6,1),'--r');
 hold on 
 plot(jj(1,1:12),IRF(1:12,6,3),'-b'); 
 title('Consumption inequality index');
 xlabel('Quarters');
 ylabel('deviation');
 saveas(figure(7),[pwd '/plots/uncrirf_LH.png'])
 
 
%% Old notes: 
% As lambda increases the IRFs become more muted/smaller in magnitude than
% when lambda is small. This makes sense since as the fraction of hand to
% mouth households increases the less responsive to shocks the economy as a
% whole will be- households will not reduce their consumption in favor of
% an asset holding that would have otherwise if they were not
% constrained/limited from participating in the financial markets.

%C_ratio = C^k/C^u is decreasing as lambda increases. This implies that
%inequality in consumption is increasing as lambda increases. 

%% New notes: 7/13

%% consider a second moment monetary policy shock: policy uncertianty instead to get sFFR 
% for i = 1:nl
%    % k = i; %no difference as k = 2, changing k = 1,2,3 doesnt change the
%     %irfs either
%     k = 2 ;%for psi_a = 1.0
%     j = 1 ;%for a policy shock
%     sd_e_nu = sd_e_nu_big(j);
%     sd_e_z = sd_e_z_big(j);
%     sd_e_a = sd_e_a_big(j);
%     sd_e_signu = sd_e_signu_big(j);
%     sd_e_sigz = sd_e_sigz_big(j);
%     sd_e_siga = sd_e_siga_big(j);
%     lambda = lambda_big(i);
%     %psi_a = psi_a_big(k/i); holding psi_a constant and varying it along with
%     %lambda both give the same magnitude IRFs. why?
%    
%     psi_a = psi_a_big(k);
%     save parameterfile sd_e_nu sd_e_z sd_e_a sd_e_siga sd_e_sigz sd_e_signu lambda psi_a
%     dynare tank_mpuncr
%     C_ratio(i,k) = 1 - gamma;
%     
%     res_c_hat(:,i) = c_hat_e_signu(:,1);
%     res_y_hat(:,i) = y_hat_e_signu(:,1);
%     res_pi(:,i) = pi_e_signu(:,1);
%     res_i_hat(:,i) = i_hat_e_signu(:,1);
%     
%     
% end
% 
% 
% diff_c31(:,1) = res_c_hat(:,3)- res_c_hat(:,1);
% diff_y31(:,1) = res_y_hat(:,3)- res_y_hat(:,1);
% diff_pi31(:,1) = res_pi(:,3)- res_pi(:,1);
% diff_i31(:,1) = res_i_hat(:,3)- res_i_hat(:,1);
