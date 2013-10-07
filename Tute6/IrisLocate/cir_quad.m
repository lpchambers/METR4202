function [Q]=cir_quad(I,xc,yc,rc,t)
%求中心为（xc,yc），rc-t/2到rc+t/2圆环内积分
It = I;
%%
% 1、计算点到圆心距离矩阵
for r = 1 : size(I,1)
    for c = 1 : size(I,2)
        Dist(r,c) = sqrt((r-yc)^2+(c-xc)^2);
        if abs(r-yc) > abs(c-xc)
            It(r,c) = 0;
        end
    end
end

%%
% 2、对环内“1”值点求和
Q = sum(It(find((Dist<=rc+t/2)&(Dist>=rc-t/2))));

%%
% 3、归一化
%Q = Q/(4*rc*t);