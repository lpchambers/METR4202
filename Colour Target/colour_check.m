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

imshow(bwarea);

Inew = I;

for i = 1:3
    mask(:,:,i) = ~bwarea;
end;
Inew(mask) = 0;
figure; imshow(Inew);

%Now get properties of the regions
rp = regionprops(bwarea, 'Area');
allArea = [rp.Area];
[sortedAreas, sortIndexes] = sort(allArea, 'descend');
bigAreas = sortedAreas(1)

% sq = strel('square',5);
% bwclose = imclose(bw_no_bord,sq);
% imshow(bwclose);
% pause;
% bwclose = ~bwclose;
% bwfill = imfo

% %Take Hough
% [H,T,R] = hough(bwclose);
% num_peaks = 50;
% P  = houghpeaks(H,num_peaks,'threshold',ceil(0.3*max(H(:))));
% 
% %Find lines
% lines = houghlines(Ibw,T,R,P,'MinLength',7);
% 
% figure; imshow(I); hold on;
% 
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% end;
% pause;
% close all;