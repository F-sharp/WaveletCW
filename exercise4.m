clc
close
clear
%% Define basic sample parameters
T = 64;
J = 6;
Signal_Length = 2048;
Order_Max = 4;
%% define scaling function
phi = zeros(1,Signal_Length);
[phi_T, psi_T, xval] = wavefun('dB4',J);
phi(1:length(phi_T))= phi_T;
% plot(xval, phi_T)
%% Create polynomials
% This section creates polynomials which will be reproduced further
Polynomial_Set = ones(Order_Max, Signal_Length);
Polynomial_basis = ((0:Signal_Length-1)/T);
index = ((0:Signal_Length-1)/T);
for i = 2:4
    Polynomial_Set(i,:) = Polynomial_basis.^(i-1);
end

%% Define Shifted kernels
index_n = 0:(32-1);
ShiftedPhi = zeros( length(index_n), Signal_Length);
for j = 1:length(index_n)
    ShiftedPhi(j,:) = circshift(phi,(j-1)*T);
end
%% Compute Cm,n
Cmn = (1/T)* Polynomial_Set * ShiftedPhi';

%% Create dirac stream
K = 2;
maxamplitude = 2;
[signal,loc, amplitude] = diracgen(T, K, Signal_Length, maxamplitude);
%% Compute sample y[n] and tau
Ysamples = signal * ShiftedPhi'; 
tau = zeros(1,size(Cmn,1));
for i = 1:size(Cmn,1)
    tau(i) = Cmn(i,:)*Ysamples';
end
%% Apply annihilate filter and vandermonde system
h = annihilatingfilter(K, tau);
t_set = roots((h))';
amplitude_set = vandermonde (tau, t_set, K);
figure()
stem(t_set, amplitude_set, 'r-O','LineStyle','-.',...
     'MarkerFaceColor','red',...
     'MarkerEdgeColor','red','linewidth',1.5);
hold on
stem(loc, amplitude, 'b-x','LineStyle','-.',...
     'MarkerFaceColor','blue',...
     'MarkerEdgeColor','blue','linewidth',1.5);
 legend('estimated Dirac stream','Original Dirac stream')
 xlabel('time')
 ylabel('amplitude')
 title('Estimation of Dirac Stream')
 grid on