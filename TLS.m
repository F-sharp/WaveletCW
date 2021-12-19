function [t_set,amp_set] = TLS(tau, K)
N = length(tau)-1;
TLSmatrix  = zeros(N-K+1, K+1);
for i= 1: N-K+1
    TLSmatrix(i,:) = tau(K+i:-1:i);
end
[~, ~, vTLS] = svd(TLSmatrix);
hTLS = vTLS(:, end);
t_set = roots((hTLS))';
amp_set = vandermonde (tau, t_set, K);
end