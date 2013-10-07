function save_images(I, D, n)

%n must be less than number of frames
l = min(size(I,4),size(D,4));
if n > l
    error('n must be less than the number of frames');
end;

picks = randperm(l);
picks = sort(picks(1:n));

Dsave = zeros(size(D,1),size(D,2),size(D,3),n, 'uint16');

for i = 1:length(picks)
    imwrite(I(:,:,:,picks(i)), strcat('image_', num2str(i), '.jpg'));
    Dsave(:,:,:,i) = D(:,:,:,picks(i));
end

save('depth.mat','Dsave');