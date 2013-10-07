function [T]=t_autoset(I)
%自动确定图象阈值
%I=imread('eye.jpg')
graycount=imhist(I);
sz=size(I);
T=0;

graycount=filter([0.5 0 0.5],1,graycount);% 邻域平均滤波,平滑灰度曲线
%figure,imhist(I);
%figure,stem([0:255],graycount,'marker','none');
%差分法求导
diff_cnt=diff(graycount);

pre_max = graycount(1);%阈值之前的峰值
for i = 2 : (length(diff_cnt)-1)
    if (graycount(i)>graycount(i-1))&(graycount(i+1)<graycount(i))&(diff_cnt(i-1)>0)&(diff_cnt(i+1)<0)
        %极大值点
        pre_max=max(graycount(i),pre_max);
        continue;
    end
    if (graycount(i)<graycount(i-1))&(graycount(i+1)>graycount(i))&(diff_cnt(i-1)<0)&(diff_cnt(i+1)>0)&(graycount(i)<0.75*pre_max)&(pre_max/(sz(1)*sz(2))>0.0025)
        %极小值点
        %且阈值点的像素数应小于此前出现的峰值点值的3/4，且这个峰值点的像素数大于总像素数的0.0025
        T=i;
        break;
    end
end
        