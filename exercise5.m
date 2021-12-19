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
for i = 2:Order_Max
    Polynomial_Set(i,:) = Polynomial_basis.^(i-1);
end
%% Define Shifted kernels
index_n = 0:31;
ShiftedPhi = zeros( length(index_n), Signal_Length);
for j = 1:length(index_n)
    ShiftedPhi(j,:) = circshift(phi,(j-1)*T);
end
%% Compute Cm,n
Cmn = (1/T)* Polynomial_Set * ShiftedPhi';
%% Create dirac stream
K = 2;
load ('samples.mat')
tau = zeros(1,4);
for i = 1:4
    tau(i) = Cmn(i,:)*y_sampled';
end
%% Apply annihilate filter and vandermonde system
h = annihilatingfilter(K, tau);
t_set = roots([h])';
amplitude_set = vandermonde (tau, t_set, K);
figure()
stem(t_set, amplitude_set, 'r--O','LineStyle','-.',...
     'MarkerFaceColor','red',...
     'MarkerEdgeColor','green');
 legend('estimated Dirac stream')
 xlabel('time')
 ylabel('amplitude')
 title('Estimation of Dirac Stream from document "samples.mat"')
 grid on
