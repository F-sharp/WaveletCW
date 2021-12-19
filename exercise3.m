clc
clear
close
K = 2;
load('tau.mat')
h = annihilatingfilter(K, tau);
t_set = roots([h])';
amplitude_set = vandermonde (tau, t_set, K);
stem(t_set, amplitude_set, 'r--O','LineStyle','-.',...
     'MarkerFaceColor','red',...
     'MarkerEdgeColor','green');
 legend('Calculated a_k and t_k')
grid on
title('Annihilating Filter Method Result')
xlabel('t_k')
ylabel('a_k')
