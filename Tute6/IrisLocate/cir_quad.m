function [Q]=cir_quad(I,xc,yc,rc,t)
%������Ϊ��xc,yc����rc-t/2��rc+t/2Բ���ڻ���
It = I;
%%
% 1������㵽Բ�ľ������
for r = 1 : size(I,1)
    for c = 1 : size(I,2)
        Dist(r,c) = sqrt((r-yc)^2+(c-xc)^2);
        if abs(r-yc) > abs(c-xc)
            It(r,c) = 0;
        end
    end
end

%%
% 2���Ի��ڡ�1��ֵ�����
Q = sum(It(find((Dist<=rc+t/2)&(Dist>=rc-t/2))));

%%
% 3����һ��
%Q = Q/(4*rc*t);