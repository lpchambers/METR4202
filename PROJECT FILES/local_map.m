function [campos, coinpos] = local_map(kinect, coins)

if nargin == 1
    coins = 0;
end
if nargin == 0
    kinect = 1;
    coins = 0;
end

%This file will generate the camera matrix
load intrinsics
i=intrinsics;
KK = [i.fc(1), i.fc(1)*i.alpha_c, i.cc(1)
    0, i.fc(2), i.cc(2)
    0, 0, 1];

%Take the picture
if kinect
    [I, D] = get_images(1);
else
    I = imread('test2.png');
end;

%FIND THE CALTAG AND NORMALIZE
% % [wPt,iPt] = caltag( I, 'output.mat', false );
% % imshow(I);
% % hold on;
% % for j=1:size(iPt,1)
% %     plot(iPt(j,2),iPt(j,1), 'gx');
% % end;
% % m = mean(iPt);

%USE SSD template matching
% % It = im2double(I);
% % T = im2double(imread('template.png'));
% % % Calculate SSD and NCC between Template and Image
% % [I_SSD,I_NCC]=template_matching(T,It);
% % % Find maximum correspondence in I_SDD image
% % [x,y]=find(I_SSD==max(I_SSD(:)));
% % % Show result
% % figure,
% % subplot(2,2,1), imshow(I); hold on; plot(y,x,'r*'); title('Result')
% % subplot(2,2,2), imshow(T); title('The eye template');
% % subplot(2,2,3), imshow(I_SSD); title('SSD Matching');
% % subplot(2,2,4), imshow(I_NCC); title('Normalized-CC');

%USE SIFT
% Read training images
train1 = rgb2gray(imread('template1.png'));
train2 = rgb2gray(imread('template2.png'));

% Extract SIFT features and descriptors
[f_train1, d_train1] = vl_sift(single(train1));
[f_train2, d_train2] = vl_sift(single(train2));

Ig = rgb2gray(I); %Get grayscale of our image
[f_I, d_I] = vl_sift(single(Ig)); %Get features/descriptors
[m1, s1] = vl_ubcmatch(d_train1, d_I);
[m2, s2] = vl_ubcmatch(d_train2, d_I);

[ctx, cty] = visualise_sift_matches(train1, Ig, f_train1, f_I, m1);

% [i2, b2] = visualise_sift_matches(train2, Ig, f_train2, f_I, m1);

%caltag coords:
figure;
imshow(Ig);
hold on
plot(cty, ctx, 'bo');

w = normalize([ctx; cty], i.fc, i.cc, i.kc, i.alpha_c);
wx = w(1);
wy = w(2);
%WORLD coord X and WORLD coord Y

%ITERATIVE PROCESS TO FIND 3-D coords of pixel point
wd = D(cty, ctx); %World depth map of target (from finding caltag on kinect)
%wd = sqrt(wx^2 + wy^2 + wz^2)
wz = sqrt(wd^2 - wx^2 - wy^2);
%PROJECT 3-D map onto pixels
%INITIAL GUESS - Centre of screen

[pix] = project_points2([wx;wy;wz], [0;0;0], [0;0;0], i.fc', i.cc', i.kc', i.alpha_c);

campos = [wx, wy, wz];

if coins
    coins = zeros(1,6);
else
    coins = [];
end
