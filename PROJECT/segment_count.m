function [money, coin_array, notes] = segment_count()
% Takes a picture with the kinect and return the approximate
% money value.

%Normalised aussie coins matrix
c5 = 1;
c10 = 2;
c20 = 3;
c50 = 4;
c1 = 5;
c2 = 6;
%Diameter matrix
CoinDiam(1) = 19.41;
CoinDiam(2) = 23.6;
CoinDiam(3) = 28.65;
CoinDiam(4) = 31.65;
CoinDiam(5) = 25;
CoinDiam(6) = 20.5;
%Coin Values
CoinVal = [0.05, 0.1, 0.2, 0.5, 1, 2];

%Find the minimum distance between coins radius
coin_thresh = max(-diff(CoinDiam/max(CoinDiam)))/2;

%Get the colour threshold
gold_hue = 0.11;
silver_hue = 0.105;
hue_thresh = 0.02;
gold_sat = 0.9;
silver_sat = 0.6;
sat_thresh = 0.03;



%Get the images
I = imread('t1rgb.png');
D = imread('t1d.png');

I_g = rgb2gray(I);
K = fspecial('gaussian');
I_blur = imfilter(I_g,K);
I_edge = edge(I_blur, 'canny');
% imshow(I_edge);

[centres, radii] = imfindcircles(I_edge, [10,20]);
imshow(I);
viscircles(centres, radii,'EdgeColor','b');

c = round(centres);
r = round(radii-1);
cmask = zeros(size(I,1),size(I,2));
for i = 1:length(radii)
    cmask(c(i,2)-r(i):c(i,2)+r(i), c(i,1)-r(i):c(i,1)+r(i)) = 1;
end;

I_circ = imoverlay(I, ~cmask, [1,1,1]);
figure; imshow(I_circ);
CCc = bwconncomp(cmask);


%Now do the Colour Masking
%Gold mask
gmask = zeros(size(I,1),size(I,2));
I_HSV = rgb2hsv(I);
for i=1:size(I,1)
    for j=1:size(I,2)
        if (abs(I_HSV(i,j,1) - gold_hue) < hue_thresh) && (abs(I_HSV(i,j,2) ...
                - gold_sat) < sat_thresh)
            gmask(i,j) = 1;
        end;
    end;
end;

gmask = gmask & cmask;

%Create a structured element circle array
se = strel('disk',4,0);
gmask = imdilate(gmask,se);
gmask = bwareaopen(gmask, 3*numel(getheight(se)));
gmask = bwfill(gmask,'holes');
figure; imshow(gmask);

CCg = bwconncomp(gmask);

%Silver mask
smask = zeros(size(I,1),size(I,2));
for i=1:size(I,1)
    for j=1:size(I,2)
        if (abs(I_HSV(i,j,1) - silver_hue) < hue_thresh) && (abs(I_HSV(i,j,2) ...
                - silver_sat) < sat_thresh)
            smask(i,j) = 1;
        end;
    end;
end;

smask = smask & cmask;

%Create a structured element circle array
se = strel('disk',4,0);
smask = imdilate(smask,se);
smask = bwareaopen(smask, 3*numel(getheight(se)));
smask = bwfill(smask,'holes');
figure; imshow(smask);

CCs = bwconncomp(smask);

if CCs.NumObjects + CCg.NumObjects ~= CCc.NumObjects
    disp('There is an error, check CCs, CCg and CCc');
end;

%Now match the radii to each coin
%GoldCoins: x, y, radii
GoldCoins = zeros(CCg.NumObjects, 3);
SilverCoins = zeros(CCs.NumObjects, 3);

for i=1:CCg.NumObjects
    [Ir,J] = ind2sub(size(I),CCg.PixelIdxList{i});
    ibar = mean(Ir);
    jbar = mean(J);
    min = 1000000;
    id = 0;
    %Now match this to radii
    for j = 1:length(centres)
        h = hypot(centres(j,1)-jbar,centres(j,2)-ibar);
        if h<min
            min = h;
            id = j;
        end;
    end;
    GoldCoins(i, 1:2) = centres(id,:);
    GoldCoins(i, 3) = radii(id);
end;

for i=1:CCs.NumObjects
    [Ir,J] = ind2sub(size(I),CCs.PixelIdxList{i});
    ibar = mean(Ir);
    jbar = mean(J);
    min = 1000000;
    id = 0;
    %Now match this to radii
    for j = 1:length(centres)
        h = hypot(centres(j,1)-jbar,centres(j,2)-ibar);
        if h<min
            min = h;
            id = j;
        end;
    end;
    SilverCoins(i, 1:2) = centres(id,:);
    SilverCoins(i, 3) = radii(id);
end;


%Now sort by coin radius
GoldCoins = sortrows(GoldCoins,3);
SilverCoins = sortrows(SilverCoins,3);

GoldRadii = GoldCoins(:,3);
SilverRadii = SilverCoins(:,3);

%Now normalise
gmax = max(GoldRadii);
smax = max(SilverRadii);
GoldRadii = GoldRadii / gmax;
SilverRadii = SilverRadii / smax;


%AS A TEST
% GoldRadii = [0.4, 0.41, 0.6, 0.61, 0.9];
% Gcoin =
%     0.4050    2.0000
%     0.6050    2.0000
%     0.9000    1.0000
% So it works

%Now put into classes
%Gcoin is array : radius, numcoins
for i=1:length(GoldRadii)
    %initialise array for first coin
    if i==1
        Gcoin = [GoldRadii(i), 1, 0];
    else
        last = size(Gcoin,1);
        if GoldRadii(i) - Gcoin(last,1) < coin_thresh
            %Add this coin to the Gcoin array in same spot
            %Calc the new average
            aveg = (Gcoin(last, 2)*Gcoin(last, 1) + GoldRadii(i)) / (Gcoin(last,2)+1);
            Gcoin(last,1) = aveg;
            Gcoin(last,2) = Gcoin(last,2)+1;
        else
            %Make newcoin spot
            Gcoin(last+1,1) = GoldRadii(i);
            Gcoin(last+1,2) = 1;
        end;
    end;
end;

%Scoin is array : radius, numcoins
for i=1:length(SilverRadii)
    %initialise array for first coin
    if i==1
        Scoin = [SilverRadii(i), 1, 0];
    else
        last = size(Scoin,1);
        if SilverRadii(i) - Scoin(last,1) < coin_thresh
            %Add this coin to the Gcoin array in same spot
            %Calc the new average
            aveg = (Scoin(last, 2)*Scoin(last, 1) + SilverRadii(i)) / (Scoin(last,2)+1);
            Scoin(last,1) = aveg;
            Scoin(last,2) = Scoin(last,2)+1;
        else
            %Make newcoin spot
            Scoin(last+1,1) = SilverRadii(i);
            Scoin(last+1,2) = 1;
        end;
    end;
end;

Gdone = 0;
Sdone = 0;
%Check the easy stuff
if size(Gcoin,1)==2
    %We have both coins
    Gcoin(1,3) = 2;
    Gcoin(2,3) = 1;
    Gdone = 1;
end;
if size(Gcoin,1)==0;
    Gdone = 1;
end;
if size(Scoin,1)==0
    Sdone = 1;
end;
if size(Scoin,1) == 4
    Scoin(1,3) = 0.05;
    Scoin(2,3) = 0.1;
    Scoin(3,3) = 0.2;
    Scoin(4,3) = 0.5;
    Sdone = 1;
end;

%Check for incomplete
if Gdone && ~Sdone
    %We have 2 gold coins and 1-3 silver coins
    G_pix = Gcoin(:,1)*gmax;
    S_pix = Scoin(:,1)*smax;
    %Find best fit for each coin
    %Radii are in ascending order, so possibilities
    poss = nchoosek([1,2,3,4],length(S_pix));
    min_d = 99999;
    idx_min = 0;
    %our checking radius
    to_match = [S_pix; G_pix];
    %normalise
    to_match = to_match / max(to_match);
    for kk = 1:size(poss, 1);
        %Assume poss and find dist
        test_index = poss(kk,:);
        testDiam = CoinDiam([test_index, c1, c2]);
        %now normalise both and check min
        testDiam = testDiam/max(testDiam);
        if norm(testDiam - to_match') < min_d;
            min_d = norm(testDiam - to_match');
            idx_min = test_index;
        end;
    end;
    %Now test_index is the index of the correct coin guess
    Scoin(:,3) = CoinVal(idx_min);
end;

if Sdone && ~Gdone
    %We have 1 gold coins and 4 silver coins
    G_pix = Gcoin(:,1)*gmax;
    S_pix = Scoin(:,1)*smax;
    %Find best fit for each coin
    %Radii are in ascending order, so possibilities
    poss = [5;6];
    min_d = 99999;
    idx_min = 0;
    %our checking radius
    to_match = [S_pix; G_pix];
    %normalise
    to_match = to_match / max(to_match);
    for kk = 1:size(poss, 1);
        %Assume poss and find dist
        test_index = poss(kk,:);
        testDiam = CoinDiam(c5,c10,c20,c50,test_index);
        %now normalise both and check min
        testDiam = testDiam/max(testDiam);
        if norm(testDiam - to_match') < min_d;
            min_d = norm(testDiam - to_match');
            idx_min = test_index;
        end;
    end;
    %Now test_index is the index of the correct coin guess
    Gcoin(:,3) = CoinVal(idx_min);
end;

if ~Sdone && ~Gdone
    %We have 1 gold coins and 1-3 silver coins
    G_pix = Gcoin(:,1)*gmax;
    S_pix = Scoin(:,1)*smax;
    %Find best fit for each coin
    %Radii are in ascending order, so possibilities
    posS = nchoosek([1,2,3,4],length(S_pix));
    poss = [posS, 5*ones(size(posS,1),1);posS, 6*ones(size(posS,1),1)];
    min_d = 99999;
    idx_min = 0;
    %our checking radius
    to_match = [S_pix; G_pix];
    %normalise
    to_match = to_match / max(to_match);
    for kk = 1:size(poss, 1);
        %Assume poss and find dist
        test_index = poss(kk,:);
        testDiam = CoinDiam(test_index);
        %now normalise both and check min
        testDiam = testDiam/max(testDiam);
        if norm(testDiam - to_match') < min_d;
            min_d = norm(testDiam - to_match');
            idx_min = test_index;
        end;
    end;
    %Now test_index is the index of the correct coin guess
    Scoin(:,3) = CoinVal(idx_min(1:end-1));
    Gcoin(:,3) = CoinVal(idx_min(end));
end;

money = dot(Gcoin(:,2),Gcoin(:,3)) + dot(Scoin(:,2),Scoin(:,3));
coin_array = [];
notes = 0;
% %Ok now find the relative best fits
% %Silver
% n = length(SilverRadii);
% pair_index = unique(nchoosek(repmat(1:4, 1,n), n), 'rows');
% [idx,d] = knnsearch(SilverRadii, CoinDiam');
