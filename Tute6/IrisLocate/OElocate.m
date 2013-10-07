function [C] = OElocate(BW,Center,R)
C = [];
Q = 0;
totle = sum(sum(BW));

delta_r = [1:min(size(BW))];
delta_r = min(size(BW))./delta_r+delta_r;
delta_r = find(delta_r == min(delta_r));

try
    Rmin = R(1);
catch
    Rmin = 1;
end
try
    Rmax = R(2);
catch
    Rmax = size(BW,1);
end

for i = 1 : size(Center,2)
    xc = Center(1,i);
    yc = Center(2,i);
    r = Rmin+delta_r/2;
    while (yc+r-delta_r <= size(BW,1)) & (xc+r-delta_r <= size(BW,2)) %| 1
        Qt = cir_quad(BW,xc,yc,r,delta_r);
        if Q < Qt
            Q = Qt;
            C = [xc,yc,r];
            if  Q >= 0.5*totle
                break;
            end
        end
        r = r + delta_r;
    end
end

%¾«¶¨Î»
Q = 0;
for r = C(3)-delta_r/2 : C(3)+delta_r/2
    Qt = cir_quad(BW,C(1),C(2),r,1);
    if Q < Qt
        Q = Qt;
        C(3) = r;
        %break;
    end
end