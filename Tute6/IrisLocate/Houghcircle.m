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
% 1. ת��Ϊ��ֵ���� 
%if ~isbw(BW)
%    I = im2bw(BW);
%else
    I = BW;
%end

[sy,sx]=size(I);

%%
% 2. �ҵ����д��任�ĵ�����. ���� 'totalpix'���任�ĵ㣨ͼ����'1'�������� 

[y,x]=find(I);
    
totalpix = length(x);

%%
% 3. ��ʼ��Hough�任����. 

HM_tmp = zeros(sy*sx,1);


%%
% 4. ���� Hough �任. 
% �ò��ִ�����Ҫһ��ѭ���������

%%
% a. ׼������
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
   
HPN = 0;% ���ڴ�����ڽ��Բ�ϵ���Ч����� 

for R = R_min : R_max
    
    R2 = R^2;
    b1 = repmat(b',[1,totalpix]);
    b2 = b1;

%%
% b. a-b�ռ��Բ����
    a1 = (round(x - sqrt(R2 - (y - b1).^2)));
    a2 = (round(x + sqrt(R2 - (y - b2).^2)));

%%
% c. ������a��b�е���Чֵת��
    b1 = b1(imag(a1)==0 & a1>0 & a1<sx);
    a1 = a1(imag(a1)==0 & a1>0 & a1<sx);
    b2 = b2(imag(a2)==0 & a2>0 & a2<sx);
    a2 = a2(imag(a2)==0 & a2>0 & a2<sx);

    ind1 = sub2ind([sy,sx],b1,a1);
    ind2 = sub2ind([sy,sx],b2,a2);

    ind = [ind1; ind2];

%%
% d. Hough�任����
    val = ones(length(ind),1);
    data=accumarray(ind,val);
    HM_tmp(1:length(data)) = data;
    HM2_tmp = reshape(HM_tmp,[sy,sx]);

% ��ʾHough�任����
%imshow(HM2,[]);

%%
% 5. ȷ�����ƥ�� R ֵ

%%
% a.���� 'maxval'���Hough �任���������ֵ����
% ԭ��ֵͼ����ͬһԲ���뾶Ϊ��ǰ R ֵ���ϵ��������ֵ
    
    maxval = max(max(HM2_tmp));

%%
% b.ͨ���Ƚϻ��maxval���ֵ���Ӷ�ȷ�����ƥ�� R ֵ
    if maxval>HPN
        HPN = maxval;
        HM = HM2_tmp;
        Rc = R;
    end
end

%%
% 6.ȷ��Բ������
[B,A] = find(HM==HPN);

C = [mean(A),mean(B),Rc];