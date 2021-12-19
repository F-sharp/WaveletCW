function  [signal,loc, amplitude] = diracgen(period, K, length, maxamp)
signal = zeros(1, length);
loc = zeros(1,K);
amplitude = zeros(1,K);
for i = 1:K
    loc = randperm(length/period,2);
    amplitude = (maxamp-1)* rand([1,K])+1;
end
signal(loc*period) = amplitude;
end