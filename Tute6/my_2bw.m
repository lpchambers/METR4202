function bw = my_2bw(rgb);
x=rgb;
sz = size(x);
bw = zeros(sz(1),sz(2));
% m=0;
for i=1:sz(1)
    for j=1:sz(2)
        %         bw(i,j) = sqrt(double(x(i,j,1)^2)+double(x(i,j,2)^2)+double(x(i,j,3)^2));
        bw(i,j) = (double(x(i,j,1))+double(x(i,j,2))+double(x(i,j,2)));
    end;
end;
m = max(max(bw));
bw = bw*255/m;
bw = uint8(bw);