function [rgb, hsv, lab] = colour_check3(row,col)
thresh = 0.01;

%Get the image
% [I D] = get_images(1);
I = imread('t1.jpg');

%Get the image
% [I D] = get_images(1);

%Convert to grayscale
Ig = rgb2gray(I);
Ibw = edge(Ig,'canny');

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(Ibw, [se90 se0]);

bw_no_bord = BWsdil;
% bw_no_bord = imclearborder(BWsdil,4);

bwf = imfill(bw_no_bord, 'holes'); %,'holes'
bwarea = bwareaopen(bwf,10000);

Inew = I;

for i = 1:3
    mask(:,:,i) = ~bwarea;
end;
Inew(mask) = 1;

I_ycbcr = rgb2ycbcr(I);
I_hsv = rgb2hsv(I);
I_hue = I_hsv(:,:,1);
I_sat = I_hsv(:,:,2);
I_val = I_hsv(:,:,3);

%Get basic colours
gm = imread('gm.png');
gm = rgb2hsv(gm);
rs = size(gm,1);
cs = size(gm,2);
c = linspace(1,cs,13);
r = linspace(1,rs,9);
out = gm(round(r(2*row)),round(c(2*col)),:);


boundl = out(1) - thresh;
boundh = out(1) + thresh;

mask = zeros(size(I_hue,1),size(I_hue,2));

%Scan I_hsv for each colour
for i = 1:size(I_hue,1)
    for j = 1:size(I_hue,2)
        if (I_hue(i,j)>boundl) && (I_hue(i,j)<boundh)
            mask(i,j) = 1;
        end
    end
end

bwf = imfill(mask, 'holes'); %,'holes'
bwarea = bwareaopen(bwf,300);

sq = strel('square',5);
bwsq = imdilate(bwarea,sq);

%Now check how many we have
CC = bwconncomp(bwsq);
if CC.NumObjects ~= 1
    %We have a problem
    if CC.NumObjects == 0
        error('Finding no objects: Try increasing threshold');
    end;
    %Take the closest to the middle
    closest = hypot(size(bwsq,1),size(bwsq,2));
    %Centre of the grid
    centre = round(size(bwsq)/2);
    mididx = 0;
    for i = 1:CC.NumObjects
        lin_coord = CC.PixelIdxList{i};
        [sub1,sub2] = ind2sub(size(bwsq),lin_coord);
        c1 = round(mean(sub1));
        c2 = round(mean(sub2));
        d = hypot(centre(1) - c1 , centre(2) - c2);
        if d<closest
            mididx = i;
            closest = d;
        end;
    end;
    %So mididx is the idx of the new centre
    bwsq = zeros(size(bwsq));
    bwsq(CC.PixelIdxList{mididx}) = 1;
end;

%Now we only have our square object

%Mask the New
Inew = I;
for i = 1:3
    nmask(:,:,i) = ~bwsq;
end;
Inew(nmask) = 0;
figure; imshow(Inew);

%Get and return the average
rgb = zeros(1,3);
hsv = zeros(1,3);
lab = zeros(1,3);
for i = 1:size(bwsq,1)
    for j = 1:size(bwsq,2)
        if bwsq(i,j) == 1
            %Sum colours
            argb = double(I(i,j,:));
            rgb = rgb + argb(:)';
            ahsv = I_hsv(i,j,:);
            hsv = hsv + ahsv(:)';
            alab = double(I_ycbcr(i,j,:));
            lab = lab + alab(:)';
        end;
    end;
end;

%Divide each by num points to get average
CC = bwconncomp(bwsq);
numPixels = cellfun(@numel,CC.PixelIdxList);
tot = sum(numPixels);
rgb = rgb/tot;
hsv = hsv/tot;
lab = lab/tot;
