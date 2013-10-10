function [money, coin_array, notes] = segment_count(kinect, show_pics)
% Takes a picture with the kinect and return the approximate
% money value.
%The coins and notes must be on a plate for this code to work
%Arguements:
%
%Input:
%kinect - boolean, if true, take a picture with the kinect,
%                  if false, choose pretaken image
%show_pics - boolean, if true show images of all imtermediate steps
%
%Output:
%money - Returns the dollar value of the coins and notes
%coin_array - A struct array with fields {c5, c10, c20, c50, AUD1, AUD2
%           which are how many of each coin type there are
%notes - A struct array with fields: money - the total note money in the
%   picture and {'five1'; 'five2'; 'ten1'; 'ten2'; 'twenty1'; 'twenty2';
%'fifty1'; 'fifty2'} which are how many of each note type there are. Note
%that five1 and five2 are both 5 dollar notes, just different sides of the
%note.
%
%Lewis Chambers October 2013

%if no arg, set no show pics
if nargin == 0
    show_pics = 0;
    kinect = 1;
end
if nargin == 1
    show_pics = 0;
end

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
% gold_hue = 0.11;
% silver_hue = 0.105;
% hue_thresh = 0.02;
% gold_sat = 0.9;
% silver_sat = 0.6;
% sat_thresh = 0.03;
gold_hue = 0.064;
silver_hue = 0.034;
hue_thresh = 0.03;
gold_sat = 0.6;
silver_sat = 0.38;
sat_thresh = 0.05;

%Get the images
if kinect
    [I, D] = get_images(1);
    save('ImD.mat','I','D');
else
    which_read = input('Read in file ''t1rgb.png''[0] or load file ImD[1]: ');
    if which_read
        load ImD;
    else
        I = imread('t1rgb.png');
        D = imread('t1d.png');
    end
end

I_g = rgb2gray(I);
K = fspecial('gaussian');
I_blur = imfilter(I_g,K);
I_edge = edge(I_blur, 'canny');
% imshow(I_edge);

%Find the plate
disp('Finding Plate');
num_plates = 0;
max_rad = 480;
while num_plates == 0;
    %Need higher sensitivity to detect concentric circles
    [plate_centres, plate_radii] = imfindcircles(I_edge, [max_rad - 50,max_rad], 'Sensitivity', 0.95);
    num_plates = length(plate_radii);
    max_rad = max_rad - 50;
end;
disp('Plate Found');
disp('Masking Plate');
%Get the max radii plate
if num_plates ~= 1
    [~, idx] = max(plate_radii);
    plate_centres = plate_centres(idx,:);
end;

%Mask the plate
c = round(plate_centres);
r = round(plate_radii);
pmask = zeros(size(I,1),size(I,2));
%This is a circlular mask
for i=1:size(I,1)
    for j=1:size(I,2)
        if norm(c-[j,i]) < r
            pmask(i,j) = 1;
        end
    end
end
%This is a square mask
% pmask(c(1,2)-r:c(1,2)+r, c(1,1)-r:c(1,1)+r) = 1;

%Save for local_map
plate_left = c(1,1)-r;
save('plate_left.mat','plate_left');

%Get the plate image
I_plate = imoverlay(I, ~pmask, [1,1,1]);
notes = get_notes(I_plate);
I_edge2 = imoverlay(I_edge, ~pmask, [0,0,0]);

if show_pics
    figure; imshow(I_plate);
    figure; imshow(I_edge2);
end;

disp('Finding Coins');
[centres, radii] = imfindcircles(I_edge, [10,30]);
if show_pics
    figure; imshow(I);
    viscircles(centres, radii,'EdgeColor','b');
end;

%Get rid of any that are not on the plate
ncentres = [];
nradii = [];
for i=1:length(radii)
    if pmask(round(centres(i,2)),round( centres(i,1))) == 1
        ncentres = [ncentres ; centres(i,:)];
        nradii = [nradii; radii(i)];
    end;
end;

centres = ncentres;
radii = nradii;

c = round(centres);
r = round(radii-1);
%Get the coin mask
cmask = zeros(size(I,1),size(I,2));
for i = 1:length(r)
    cmask(c(i,2)-r(i):c(i,2)+r(i), c(i,1)-r(i):c(i,1)+r(i)) = 1;
end;

I_circ = imoverlay(I, ~cmask, [1,1,1]);
if show_pics
    figure; imshow(I_circ);
end;
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
if show_pics
    figure; imshow(gmask);
end;
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
if show_pics
    figure; imshow(smask);
end;

CCs = bwconncomp(smask);

%Some coins are missing, or something is tricking us
if CCs.NumObjects + CCg.NumObjects ~= CCc.NumObjects
    disp('Ignoring extra detected circles');
end;

if CCs.NumObjects + CCg.NumObjects == 0
    %We have no coins
    money = notes.money;
    coin_array.c5 = 0;
    coin_array.c10 = 0;
    coin_array.c20 = 0;
    coin_array.c50 = 0;
    coin_array.AUD1 = 0;
    coin_array.AUD2 = 0;
    return;
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
disp('Found Coins');

%Save all coin locations for local_map
all_coins = [GoldCoins; SilverCoins];
all_coins = all_coins(:,1:2);
save('all_coins.mat','all_coins');

disp('Sorting coins');
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
Gcoin = [0,0,0];
Scoin = [0,0,0];
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

money = dot(Gcoin(:,2),Gcoin(:,3)) + dot(Scoin(:,2),Scoin(:,3)) + notes.money;
coi = [Scoin(:,2:3); Gcoin(:,2:3)];
CoinName = {'c5'; 'c10'; 'c20'; 'c50'; 'AUD1'; 'AUD2'};

for i=1:length(CoinVal)
    idx = ismember(coi(:,2), CoinVal(i));
    idx = find(idx, 1);
    if isempty(idx)
        eval(['coin_array.' CoinName{i} '=0;']);
    else
        eval(['coin_array.' CoinName{i} '=coi(idx,1);']);
    end
end
disp('done');
end