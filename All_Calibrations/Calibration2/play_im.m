function play_im(I)
for i = 1:size(I,4)
    imshow(I(:,:,:,i));
    pause(0.0365);
end;