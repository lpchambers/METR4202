function [T]=t_autoset(I)
%�Զ�ȷ��ͼ����ֵ
%I=imread('eye.jpg')
graycount=imhist(I);
sz=size(I);
T=0;

graycount=filter([0.5 0 0.5],1,graycount);% ����ƽ���˲�,ƽ���Ҷ�����
%figure,imhist(I);
%figure,stem([0:255],graycount,'marker','none');
%��ַ���
diff_cnt=diff(graycount);

pre_max = graycount(1);%��ֵ֮ǰ�ķ�ֵ
for i = 2 : (length(diff_cnt)-1)
    if (graycount(i)>graycount(i-1))&(graycount(i+1)<graycount(i))&(diff_cnt(i-1)>0)&(diff_cnt(i+1)<0)
        %����ֵ��
        pre_max=max(graycount(i),pre_max);
        continue;
    end
    if (graycount(i)<graycount(i-1))&(graycount(i+1)>graycount(i))&(diff_cnt(i-1)<0)&(diff_cnt(i+1)>0)&(graycount(i)<0.75*pre_max)&(pre_max/(sz(1)*sz(2))>0.0025)
        %��Сֵ��
        %����ֵ���������ӦС�ڴ�ǰ���ֵķ�ֵ��ֵ��3/4���������ֵ�����������������������0.0025
        T=i;
        break;
    end
end
        