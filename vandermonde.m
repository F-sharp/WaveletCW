function amplitude = vandermonde (tau, t_set, K)
Vmatrix = zeros(K,K);
for i = 1:K
    if i == 1
        Vmatrix(i,:) = ones(1,K);
    else
        Vmatrix(i,:) = t_set;
    end
end
Vvector = tau(1:K)';
amplitude = (Vmatrix\Vvector)';
end