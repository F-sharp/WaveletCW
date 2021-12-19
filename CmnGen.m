function  [ShiftedPhi, Cmn] = CmnGen(Order, iter, Signal_Length, T)

%% define scaling function
phi = zeros(1,Signal_Length);
[phi_T, ~, ~] = wavefun(sprintf('dB%d',Order),iter);
phi(1:length(phi_T))= phi_T;
% plot(xval, phi_T)
%% Create polynomials
% This section creates polynomials which will be reproduced further
Polynomial_Set = ones(Order, Signal_Length);
Polynomial_basis = ((0:Signal_Length-1)/T);
for i = 2:Order
    Polynomial_Set(i,:) = Polynomial_basis.^(i-1);
end
%% Define Shifted kernels
index_n = 0:(32-1);
ShiftedPhi = zeros( length(index_n), Signal_Length);
for j = 1:length(index_n)
    ShiftedPhi(j, :) = [zeros(1, (j-1) * T), phi(1: end - (j-1) * T)];
end
%% Compute Cm,n
Cmn = (1/T)* Polynomial_Set * ShiftedPhi';
end