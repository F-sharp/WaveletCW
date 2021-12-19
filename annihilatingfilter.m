function h = annihilatingfilter(K, tau)

N = length(tau)-1;
YWmatrix = zeros(N-K+1, K);
for i= 1: N-K+1
    YWmatrix(i,:) = tau(K+i-1:-1:i);
end
YWvector = -tau(K+1:N+1)';
h = [1;YWmatrix\YWvector];
end