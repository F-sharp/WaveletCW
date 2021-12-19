clear
close all
% Since original length x(t)=2048, sample period T=64
% y[n] will equal to 32, iteration time J equals 2^J = 64
% iteration number should equal to 6
% dB4 will have 4 zeros @ 0, so it is chosen
% Basic Parameters define
T = 64;
J = 6;
Signal_Length = 2048;
Order_Spline = 4;

%% Define B-Spline scaling function.
bspline = zeros(1,Signal_Length);
boxfunction = ones(1,T);
for i = 1:Order_Spline
    if i == 1
        bspline_T = boxfunction;
    else
        bspline_T = conv(boxfunction,bspline_T)/T;
    end
end
figure()
plot(bspline_T,'LineWidth',2)
title('Cubic B-spline scaling function')
grid on
bspline(1:length(bspline_T))= bspline_T;
%% Define Support of kernel
L = round(length(bspline_T)/T);
index_n = 0:(32-L);
%% Define Shifted kernels
ShiftedBspline = zeros( length(index_n), Signal_Length);
for j = 1:length(index_n)
    ShiftedBspline(j,:) = circshift(bspline,(j-1)*T);
end

%% Calculate dual basis according to gram matrix

dual_bspline_T = find_dual(bspline_T);
dual_bspline = zeros(1,Signal_Length);
dual_bspline(1:length(bspline_T))= dual_bspline_T;
%% Define shifted dual
ShiftedDual = zeros( length(index_n), Signal_Length);
for j = 1:length(index_n)
    ShiftedDual(j,:) = circshift(dual_bspline,(j-1)*T);
end
%% Create polynomials
% This section creates polynomials which will be reproduced further
Polynomial_Set = ones(Order_Spline, Signal_Length);
Polynomial_basis = ((0:Signal_Length-1)/T);
index = ((0:Signal_Length-1)/T);
for i = 2:4
    Polynomial_Set(i,:) = Polynomial_basis.^(i-1);
end

%% Compute Cm,n
Cmn = (1/T)* Polynomial_Set * ShiftedDual';

%% Reconstruction Polynomials:
Kernel_Set = zeros(Order_Spline * length(index_n), Signal_Length);
ReconstructedPolynomials = zeros(Order_Spline, Signal_Length);
for m = 1:4
    KernelSum = zeros(1, Signal_Length);
    for n = 1:length(index_n)
        Kernel_Set(n+(m-1)*length(index_n),:) = Cmn(m,n) * ShiftedBspline (n,:);
        KernelSum =  Kernel_Set(n+(m-1)*length(index_n),:) + KernelSum;
    end
    ReconstructedPolynomials(m,:) = KernelSum;
end


%% Plotting result
for m = 1:4
    figure(2)
    subplot(2,2,m)
    p1 = plot(index, ReconstructedPolynomials(m,:),'LineWidth',2);
    hold on 
    p2 = plot(index, Polynomial_Set(m,:),'LineWidth',2);
    for n = 1:length(index_n)
        plot (index, Kernel_Set(n+(m-1)*length(index_n),:))
    end
    legend([p1,p2],'Reconstruct polynomial',sprintf('Original order %d polynomial',m-1))
    title(sprintf('Cubic B-spline kernels recover polynomial with order %d',m-1))
    xlabel('sample n from 0 to 32-L')
    ylabel('polynomial value')
end