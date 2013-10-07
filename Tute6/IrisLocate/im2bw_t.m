function [BW]=im2bw_t(I,t)
%��ֵ�ָͬʱ���г�����Ե���

if nargin == 1
    t = t_autoset(I);
end

sz=size(I);
%����ͬ����С�ı�Եͼ��
BW=repmat(logical(uint8(0)),sz(1),sz(2));

for r = 3 : sz(1)-2
    for c = 3 : sz(2)-2
        if I(r,c)<t
            if (I(r-1,c-1)<t)&(I(r-1,c)<t)&(I(r-1,c+1)<t)&(I(r,c-1)<t)&(I(r,c+1)<t)&(I(r+1,c-1)<t)&(I(r+1,c)<t)&(I(r+1,c+1)<t)
                BW(r,c) = 0;
            else
                BW(r,c) = 1;
            end
        else
            BW(r,c) = 0;
        end
    end
end

%������ܴ��ڵ�ͼƬ�߽�
for r = 1 : sz(1)
    BW(r,1:2) = 0;
    BW(r,(size(BW,2)-1):size(BW,2)) = 0;
end
for c = 1 : sz(2)
    BW(1:2,c) = 0;
    BW((size(BW,1)-1):size(BW,1),c) = 0;
end