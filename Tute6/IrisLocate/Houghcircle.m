function [C,HM]=Houghcircle(BW,Rp)
%HOUGHCIRCLE - detects circles in a binary image.
%
%Comments:
%       Function uses Standard Hough Transform to detect circles in a binary image.
%       According to the Hough Transform for circles, each pixel in image space
%       corresponds to a circle in Hough space and vise versa. 
%
%Usage: [C,HM]=Houghcircle(BW,Rp)
%
%Input:
%       BW - a binary image. image pixels that have value equal to 1 are interested
%               pixels for HOUGHLINE function.
%       Rp=[R_min,Rmax]
%          - a vargin.when it's given,do Hough Transform from R_min to R_max.
%
%Outputs:
%       C=[y0detect,x0detect,r0detect]
%           y0detect    - row coordinates of detected circles.
%           x0detect    - column coordinates of detected circles. 
%           r0detect    - radius of circles.
%       HM          - Hough Matrix
%
%May 20,2007        - Homework of Image Processing Course,NJU.ESE.04
%StudentNum         - 041180114

%%
% 1. 转换为二值矩阵 
%if ~isbw(BW)
%    I = im2bw(BW);
%else
    I = BW;
%end

[sy,sx]=size(I);

%%
% 2. 找到所有待变换的点坐标. 变量 'totalpix'待变换的点（图象中'1'）的总数 

[y,x]=find(I);
    
totalpix = length(x);

%%
% 3. 初始化Hough变换矩阵. 

HM_tmp = zeros(sy*sx,1);


%%
% 4. 进行 Hough 变换. 
% 该部分代码需要一次循环即可完成

%%
% a. 准备工作
b = 1:sy;
a = zeros(sy,totalpix);
    
if nargin == 1
    R_min = 1;
    R_max = max(max(x),max(y));
else
    R_min = Rp(1);
    R_max = Rp(2);
end

y = repmat(y',[sy,1]);
x = repmat(x',[sy,1]);
   
HPN = 0;% 用于存放落在结果圆上的有效点个数 

for R = R_min : R_max
    
    R2 = R^2;
    b1 = repmat(b',[1,totalpix]);
    b2 = b1;

%%
% b. a-b空间的圆方程
    a1 = (round(x - sqrt(R2 - (y - b1).^2)));
    a2 = (round(x + sqrt(R2 - (y - b2).^2)));

%%
% c. 将矩阵a、b中的有效值转移
    b1 = b1(imag(a1)==0 & a1>0 & a1<sx);
    a1 = a1(imag(a1)==0 & a1>0 & a1<sx);
    b2 = b2(imag(a2)==0 & a2>0 & a2<sx);
    a2 = a2(imag(a2)==0 & a2>0 & a2<sx);

    ind1 = sub2ind([sy,sx],b1,a1);
    ind2 = sub2ind([sy,sx],b2,a2);

    ind = [ind1; ind2];

%%
% d. Hough变换矩阵
    val = ones(length(ind),1);
    data=accumarray(ind,val);
    HM_tmp(1:length(data)) = data;
    HM2_tmp = reshape(HM_tmp,[sy,sx]);

% 显示Hough变换矩阵
%imshow(HM2,[]);

%%
% 5. 确定最佳匹配 R 值

%%
% a.变量 'maxval'存放Hough 变换矩阵中最大值，即
% 原二值图中在同一圆（半径为当前 R 值）上点数的最大值
    
    maxval = max(max(HM2_tmp));

%%
% b.通过比较获得maxval最大值，从而确定最佳匹配 R 值
    if maxval>HPN
        HPN = maxval;
        HM = HM2_tmp;
        Rc = R;
    end
end

%%
% 6.确定圆心坐标
[B,A] = find(HM==HPN);

C = [mean(A),mean(B),Rc];