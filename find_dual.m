function dual_kernel = find_dual(kernel)
% This function apply gram matrix to calculate dual basis of kernel
% kernel is input basis
% dual_kernel is output dual basis
GramMatrix = kernel'*kernel;
Inv = pinv(GramMatrix);
Inv = Inv/norm(Inv);
dual_kernel = kernel*Inv;
end