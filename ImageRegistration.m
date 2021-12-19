function [Tx_RGB Ty_RGB]= ImageRegistration (threshold)
% *************************************************************************
% Wavelets and Applications Course - Dr. P.L. Dragotti
% MATLAB mini-project 'Sampling Signals with Finite Rate of Innovation'
% Exercice 6
% *************************************************************************
% 
% FOR STUDENTS
%
% This function registers the set of 40 low-resolution images
% 'LR_Tiger_xx.tif' and returns the shifts for each image and each layer
% Red, Green and Blue. The shifts are calculated relatively to the first
% image 'LR_Tiger_01.tif'. Each low-resolution image is 64 x64 pixels.
%
%
% OUTPUT:   Tx_RGB: horizontal shifts, a 40x3 matrix
%           Ty_RGB: vertical shifts, a 40x3 matrix
%
% NOTE: _Tx_RGB(1,:) = Ty_RGB(1,:) = (0 0 0) by definition.
%       _Tx_RGB(20,2) is the horizontal shift of the Green layer of the
%       20th image relatively to the Green layer of the firs image.
%
%
% OUTLINE OF THE ALGORITHM:
%
% 1.The first step is to compute the continuous moments m_00, m_01 and m_10
% of each low-resolution image using the .mat file called:
% PolynomialReproduction_coef.mat. This file contains three matrices
% 'Coef_0_0', 'Coef_1_0' and 'Coef_0_1' used to calculate the continuous
% moments.
%
% 2.The second step consists in calculating the barycenters of the Red,
% Green and Blue layers of the low-resolution images.
%
% 3.By computing the difference between the barycenters of corresponding 
% layers between two images, the horizontal and vertical shifts can be 
% retrieved for each layer.
%
%
% Author:   Loic Baboulaz
% Date:     August 2006
%
% Imperial College London
% *************************************************************************


% Load the coefficients for polynomial reproduction
load('PolynomialReproduction_coef.mat','Coef_0_0','Coef_1_0','Coef_0_1');
Tx_RGB = zeros(40, 3);
Ty_RGB = zeros(40, 3);
N = 40;
barycenter = zeros(3,2);
barycenter_ref = zeros(3,2);
t = Tiff(sprintf('LR_Tiger_01.tif'),'r');
imageData = double(read(t));
imageData = imageData/255;
imageData(imageData <threshold) = 0;
for m = 1:3
    moment_0_0 = sum(sum(Coef_0_0.*imageData(:,:,m)));
    moment_0_1 = sum(sum(Coef_0_1.*imageData(:,:,m)));
    moment_1_0 = sum(sum(Coef_1_0.*imageData(:,:,m)));
    barycenter_ref(m,:) = [moment_1_0/moment_0_0, moment_0_1/moment_0_0];
end
% for the first photo, since it is reference, so Tx_RGB and Ty_RGB should
% be zero
for i = 2:N
    if i <= 9
        t = Tiff(sprintf('LR_Tiger_0%d.tif',i),'r');
    else
        t = Tiff(sprintf('LR_Tiger_%d.tif',i),'r');
    end
    imageData = double(read(t));
    imageData = imageData/255;
    imageData(imageData <threshold) = 0;
    for m = 1:3
        moment_0_0 = sum(sum(Coef_0_0.*imageData(:,:,m)));
        moment_0_1 = sum(sum(Coef_0_1.*imageData(:,:,m)));
        moment_1_0 = sum(sum(Coef_1_0.*imageData(:,:,m)));
        barycenter(m,:) = [moment_1_0/moment_0_0, moment_0_1/moment_0_0];
    end
    diff = barycenter - barycenter_ref;
    Tx_RGB(i,:) = diff(:,1);
    Ty_RGB(i,:) = diff(:,2);
end
    
end



