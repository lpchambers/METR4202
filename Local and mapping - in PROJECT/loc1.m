I = imread('test2.png');
[wPt,iPt] = caltag( I, 'output.mat', false );
imshow(I);
hold on;
for i=1:size(iPt,1)
    plot(iPt(i,2),iPt(i,1), 'gx');
end;

