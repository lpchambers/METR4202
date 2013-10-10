function[OYrgb, OYhsv, OYycbcr, Nrgb, Nhsv, Nycbcr] = findTHIS()
[I, D] = get_images(1);

Ho = 246;
Wo= 407;
Ig = rgb2gray(I);
Ibw = edge(Ig,'canny');
bwf = imfill(Ibw, 'holes'); %,'holes'
figure; imshow(bwf);
Inew = I;

for i = 1:3
    mask(:,:,i) = ~bwf;
end;
Inew(mask) = 0;
figure; imshow(Inew);	


% Read images 

template = rgb2gray(imread('THIS.png')); 
test_1 = rgb2gray(Inew); 
 
% Find correlations using Zero Normalised Cross Correlation 
S = isimilarity(template, test_1, @zncc); 
 
% Find the index of the best match 
indices = find(S == max(max(S))); 
 
% Convert the (1D) index to (2D) matrix subscript values 
[y x] = ind2sub(size(S), indices); 
 
% Plot the  images 
figure; 
subplot(1,3,1); 
imshow(test_1); 
hold on; 
plot(x, y, 'rx'); 
title('Test Image'); 
 
subplot(1,3,2); 
imshow(S); 
hold on; 
plot(x, y, 'rx'); 
title('Similarity Image'); 

subplot(1,3,3);
imshow(D);
hold on;
plot(x,y, 'rx');
title('Depth Image');

Hi = ((Ho * 4.73)/(D(y,x) - 4.73))/0.0078; 
Wi = ((Wo * 4.73)/(D(y,x) - 4.73))/0.0078;

xmin = x - round(Wi/2);
ymin = y - round(Hi/2);
width = round(Wi);
height = round(Hi);

Ic =  imcrop(I, [xmin ymin width height]);
[h, w, d,] = size(Ic);
h1step = h/2.675;
w1step = w/1.11;
h2step = h/1.15;
w2step = w/2.682;
figure;
imshow(Ic);
hold on;

plot (w1step, h1step, 'go');
plot (w2step , h2step , 'go');
hsvIc = rgb2hsv(Ic);
YCbCrIc = rgb2ycbcr(Ic);
OYrgb = impixel(Ic,w1step,h1step);
OYhsv = impixel(hsvIc,w1step,h1step);
OYycbcr = impixel(YCbCrIc,w1step,h1step);
Nrgb = impixel(Ic,w2step,h2step);
Nhsv = impixel(hsvIc,w2step,h2step);
Nycbcr = impixel(YCbCrIc,w2step,h2step);