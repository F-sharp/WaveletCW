function [t_set,amp_set] = CadTLS(tau, K)
N = length(tau)-1;
matrix  = zeros(N-K+1, K+1);
for i= 1: N-K+1
    matrix(i,:) = tau(K+i:-1:i);
end
IsDeficient = rank(matrix) == K;
temp = zeros(size(matrix));
[u, lambda, v] = svd(matrix);
while ~IsDeficient
    lambda(size(lambda, 2), size(lambda, 2)) = 0;
    matrix = u*lambda*v';
    for m = 1: size(matrix, 1)
        for n = 1: size(matrix, 2)
            temp(m, n) = mean(diag(matrix, n - m));
        end
    end
    matrix = temp;
    [u, lambda, v] = svd(matrix);
    % check whether it is full rank
%     isDeficient = rank(tauNoisyMatrix) == nDiracs;
    IsDeficient = rank(lambda) == K;
end
h = v(:, end);
t_set = roots((h))';
amp_set = vandermonde (tau, t_set, K);
end