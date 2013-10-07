%IMPROFILE
%Get the image
% [I D] = get_images(1);

I = imread('test1.png');

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
% rp = regionprops(bwarea, 'Area');
% allArea = [rp.Area];
% [sortedAreas, sortIndexes] = sort(allAreas, 'ascend');
% smallAreas = sortedAreas(1:10)


J = imread('gm.jpg');

[fa, da] = vl_sift(single(rgb2gray(I)));
[fb, db] = vl_sift(single(rgb2gray(J)));
[matches, scores] = vl_ubcmatch(da, db) ;
% visualise_sift_matches(I,J,fa,fb,matches);

newmatch = zeros(2,1);
k=1;
%Filter out the ones we don't think are good
for i = i:size(matches,2)
    pt = fa(1:2,matches(1,i));
    if bwarea(round(pt(1)),round(pt(2))) == 1
        newmatch(1:2,k);
        k=k+1;
    end;
end;

visualise_sift_matches(Inew,J,fa,fb,newmatches);