function [campos, coinpos] = local_map(kinect, coins)
%Find the camera position relative to a central frame
%Also find coin positions (only if kinect == 0)
%All co-ordinates in this function are as XY not row-column
%Co-ordinates defined in mm
%Camera position rpy is defined as:
%Roll - about x (first)     }
%Pitch - about y (second)   }  All angles in radians
%Yaw - about z (third)      }
%
%Campos returns as a 1x6 vector:
%Campos = [xpos, ypos, zpos, roll, pitch, yaw

if nargin == 1
    coins = 0;
end
if nargin == 0
    kinect = 1;
end
if kinect == 1
    coins = 0;
end

%dxd is the real world distance of dx(pixelspace) || dyd similarly
dxd = 235; %in mm
dyd = 118; %in mm

%This part of the file will generate the camera matrix
load intrinsics
i=intrinsics;
% KK = [i.fc(1), i.fc(1)*i.alpha_c, i.cc(1)
%     0, i.fc(2), i.cc(2)
%     0, 0, 1];

%Take the picture
if kinect
    [I, D] = get_images(1);
else
    which_read = input('Read in file ''ctag3.jpg''[0] or load file ImD[1]: ');
    if which_read
        load ImD;
        load all_coins
    else
        I = imread('ctag3.jpg');
        D = imread('t1d.png');
    end    
end;
figure; imshow(I);

%undistort image
%for the undistort script
% % fc = i.fc; kc=i.kc; cc=i.cc; alpha_c = i.alpha_c;
% % %ONLY UNDISTORT IF REALLY NEED
% % edit_undistort_image;
% % I = I2;

%FIND THE CALTAG AND NORMALIZE
[wPt,iPt] = caltag( I, 'output.mat', false );
figure; imshow(I);
hold on;
for j=1:size(iPt,1)
    plot(iPt(j,2),iPt(j,1), 'gx');
end;

%Check if caltag deteced
if isempty(wPt)
    disp('Caltag not detected due to quality of image or lighting');
    if coins
        disp('Will return coinpos relative to camera frame...maybe');
        %YAYAYAYAY Get to do fun camera matrix maths
        coinpos = zeros(size(all_coins,1),3);
        for i=1:size(all_coins,1)
            %since all_coins is row-col and ctx/y is xy
            ctx = all_coins(i,2);
            cty = all_coins(i,1);
            %ctx and cty are x and y positions of coins
            w = normalize([ctx; cty], i.fc, i.cc, i.kc, i.alpha_c);
            wx = w(1);
            wy = w(2);
            %WORLD coord X and WORLD coord Y
            
            wd = D(cty, ctx); %World depth map of coin
            wz = sqrt(wd^2 - wx^2 - wy^2);
            coinpos(i,1) = wx;
            coinpos(i,2) = wy;
            coinpos(i,3) = wz;
        end
        
    else
        coinpos = [];
    end
else
    disp('Caltag Frame detected, calculating position');
    %wpt: 00 = bottom right 
    %     04 = top right     
    %     80 = bottom left   
    %     84 = top left      
    ibr = find(ismember(wPt,[0,0], 'rows'));
    itr = find(ismember(wPt,[0,4], 'rows'));
    ibl = find(ismember(wPt,[8,0], 'rows'));
    itl = find(ismember(wPt,[8,4], 'rows'));
    %Assume we have the corner points
    dx1 = iPt(ibr,:) - iPt(ibl,:);
    dx2 = iPt(itr,:) - iPt(itl,:);
    dx = [mean([dx1(1),dx2(1)]), mean([dx1(2),dx2(2)])];
    dy1 = iPt(itl,:) - iPt(ibl,:);
    dy2 = iPt(itr,:) - iPt(ibr,:);
    dy = [mean([dy1(1),dy2(1)]), mean([dy1(2),dy2(2)])];
    %dx and dy are vectors on the axis of real world length dxd and dyd
    
    origin = iPt(ibl,:) - 0.07*dx - 0.285*dy;
    hold on
    plot(origin(2), origin(1), 'r*');
    %Could also do corner detetion, but nahh
    %Want to find where camera centre is on flat frame plane
    cc = i.cc;
    xy = cc - origin;
    %want to find a and b such that:
    %xy_dist_vector = a*dx + b*dy
    %     xy(1) = a*dx(1) + b*dy(1)
    %     xy(2) = a*dx(2) + b*dy(2)
    %solution:
    a = (xy(1)/dy(1) - xy(2)/dy(2)) / (dx(1) - dx(2));
    b = xy(2)/dy(2) - a*dx(2);
    
    %So we know that we are 'a' lots of dx's in the x direction of the
    %frame and 'b' lots of dy's in y dir, so world x and y pos of cam:
    wx_cam = a*dxd;
    wy_cam = b*dyd;

    %The depth map will give the straight line distance, so will call it r
    %where r=sqrt(wx^2 + wy^2 + wz^2)   ||    r is in mm
    r = D(origin(2), origin(1));
    %so wz_cam is:
    wz_cam = sqrt(r^2 - wx_cam^2 - wy_cam^2);
    
    %Now calcluate the rpy
    %Since camera is directly above, roll = 0 radians
    cam_roll = 0;
    %Since the camera view is facing opposite direction as the frame, pitch
    %is pi radians
    cam_pitch = pi;
    %note that yaw is inverted since we flipped the orientation
    %yaw is the angle of dx. so yaw = -atan(dx(2) - dx(1))
    yaw = atan(dx(2) - dx(1));
    %check for quadrant 2 or 3
    if dx(1) < 0
        yaw = yaw + pi;
    end
    %now compensate for the switch
    yaw = -yaw;
    
    %Put it all in a vector for return
    campos = [wx_cam, wy_cam, wz_cam, cam_roll, cam_pitch, yaw];
    if coins
        %Now locate the coins
        %%%
        %%%
        %%%
        %%%
    else
        coinpos = [];
    end
end







% [pix] = project_points2([wx;wy;wz], [0;0;0], [0;0;0], i.fc', i.cc', i.kc', i.alpha_c);
% 
% campos = [wx, wy, wz];
% 
% if coins
%     coins = zeros(1,6);
% else
%     coins = [];
% end

%%%%%PAST CALTAG FINDER METHODS
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
% % % Read training images
% % train1 = rgb2gray(imread('template1.png'));
% % train2 = rgb2gray(imread('template2.png'));
% % 
% % % Extract SIFT features and descriptors
% % [f_train1, d_train1] = vl_sift(single(train1));
% % [f_train2, d_train2] = vl_sift(single(train2));
% % 
% % Ig = rgb2gray(I); %Get grayscale of our image
% % [f_I, d_I] = vl_sift(single(Ig)); %Get features/descriptors
% % [m1, s1] = vl_ubcmatch(d_train1, d_I);
% % [m2, s2] = vl_ubcmatch(d_train2, d_I);