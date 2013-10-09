function [campos, coinpos] = local_map(kinect, coins)

if nargin == 1
    coins = 0;
end
if nargin == 0
    kinect = 1;
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
[wPt,iPt] = caltag( I, 'output.mat', false );
imshow(I);
hold on;
for j=1:size(iPt,1)
    plot(iPt(j,2),iPt(j,1), 'gx');
end;

m = mean(iPt);
%caltag coords:
ctx = m(1);
cty = m(2);
plot(cty, ctx, 'bo');

w = normalize([ctx; cty], i.fc, i.cc, i.kc, i.alpha_c);
wx = w(1);
wy = w(2);
%WORLD coord X and WORLD coord Y

%ITERATIVE PROCESS TO FIND 3-D coords of pixel point
wd = 2;%D(ctx, cty); %World depth map of target (from finding caltag on kinect)
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
