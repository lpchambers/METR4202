% colour_check4

%colour thresh
thresh = 0.05;
%Hardcode HSV values
shsv = double([...
    0.05, 0.439, 0.447
    0.0521, 0.33, 0.761
    0.59, 0.404, 0.612
    0.246, 0.407, 0.424
    0.67, 0.273, 0.69
    0.463, 0.479, 0.745
    0.0782, 0.829, 0.847
    0.634, 0.564, 0.647
    0.979, 0.572, 0.761
    0.778, 0.449, 0.42
    0.202, 0.679, 0.733
    0.107, 0.817, 0.902
    0.646, 0.697, 0.596
    0.329, 0.537, 0.584
    0.986, 0.751, 0.694
    0.137, 0.891, 0.933
    0.896, 0.559, 0.729
    0.531, 1, 0.647
    0.139, 0.0248, 0.949
    0.167, 0.00498, 0.788
    0.333, 0.00621, 0.631
    0.167, 0.0164, 0.478
    0.5, 0.012, 0.325
    0,0,0.192]);
    

%Read image
I = imread('test1.png');
imshow(I)
[Ii, Ij, ~] = size(I);

%Get HSV and hsv channels
Ihsv = rgb2hsv(I);
I_h = Ihsv(:,:,1);
I_s = Ihsv(:,:,2);
I_v = Ihsv(:,:,3);

%Orange yellow and neighbours
OYN = [6, 12, 18, 11];
OY_mask = zeros(Ii, Ij, 4);
mk = 1;
%Find each colour
for col = OYN    %1:size(shsv,1)
    mask = zeros(Ii, Ij);
    hc = shsv(col, 1);
    sc = shsv(col, 2);
    for i = 1:Ii
        for j = 1:Ij
            if (abs(I_h(i,j)-hc)<thresh) %&& (abs(I_s(i,j)-sc)<4*thresh)
                mask(i,j) = 1;
            end
        end
    end
    %now fix the mask a little
    bwf = imfill(mask, 'holes');
    %Remove blocks B>1000, B<300
    bwarea = xor(bwareaopen(bwf,300), bwareaopen(bwf,1000));
    %This would show them
    %figure; imshow(imoverlay(I, bwarea, [1,1,1]));
    
    %Store it in an array
    OY_mask(:,:,mk) = bwarea;
    mk = mk+1;
end

%get midpt of each (a, b, c, d)
for kk=1:size(OY_mask,3)
    CC = bwconncomp(OY_mask(:,:,kk));
    for j = 1:CC.NumObjects%%%%%%%%%%%%%%%
end

pause;
close all;
