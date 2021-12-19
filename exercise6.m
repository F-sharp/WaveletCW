% For K = 2, the degree of scaling function should be at least 2K+1
% Here, moments of degree 5:8
clc
clear
close
%% Define basic sample parameters
T = 64;
J = 6;
Signal_Length = 2048;
Order_set = [5:9];
sigma_set = [0.1, 1, 10];
noise_set = randn(1,9);
K = 2;
%% Generate delta stream
maxamplitude = 5;
[signal,loc, amplitude] = diracgen(T, K, Signal_Length, maxamplitude);
%% Different order of tau function
for i = 1:length(Order_set)
    %% generate Cmn and shifted kernel set
    [ShiftedPhi, Cmn] = CmnGen(Order_set(i), J, Signal_Length, T);
    %% Generate tau
    Ysamples = signal * ShiftedPhi'; 
    tau = zeros(1,size(Cmn,1));
    for x = 1:size(Cmn,1)
        tau(x) = Cmn(x,:)*Ysamples';
    end
    %% Add noise
    noise = 10*noise_set(1:size(Cmn,1));
    tau_noise = tau + noise;
    [t_TLS,amp_TLS] = TLS(tau_noise, K);
    [t_CadTLS,amp_CadTLS] = CadTLS(tau_noise, K); 
    subplot(5,1,i)
    stem(loc, amplitude, 'r-O','LineStyle','-.',...
     'MarkerFaceColor','red',...
     'MarkerEdgeColor','red','linewidth',1.5);
     hold on
     stem(t_TLS,amp_TLS, ':diamondr','LineStyle','-.',...
         'Color','blue',...
     'MarkerFaceColor','blue',...
     'MarkerEdgeColor','blue','linewidth',1.5);
     hold on
     stem(t_CadTLS,amp_CadTLS, 'g-x','LineStyle','-.',...
     'MarkerFaceColor','green',...
     'MarkerEdgeColor','green','linewidth',1.5);
     legend('Original Dirac stream','TLS result','CadTLS result')
     xlabel('time')
     ylabel('amplitude')
     ylim([0 5])
     title(sprintf('Estimate dirac stream when with 10 noise variance with order %d',i+4))
     grid on
end
