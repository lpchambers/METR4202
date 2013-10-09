function [I,D] = get_images(n)

addpath('Kinect_files')
SAMPLE_XML_PATH='Kinect_files/SamplesConfig.xml';

% Start the Kinect Process
% filename='Example/SkelShort.oni';
%KinectHandles=mxNiCreateContext(SAMPLE_XML_PATH,filename);

% To use the Kinect hardware use :
KinectHandles=mxNiCreateContext(SAMPLE_XML_PATH);

%Assuming 480 x 640
I = zeros(480,640,3,n, 'uint8');
D = ones(480,640,1,n, 'uint16');

for i=1:n
    I0=mxNiPhoto(KinectHandles); I0=permute(I0,[3 2 1]);
    D0=mxNiDepth(KinectHandles); D0=permute(D0,[2 1]);
    mxNiUpdateContext(KinectHandles);
    I(:,:,:,i) = I0;
    D(:,:,:,i) = D0;
end;

% subplot(1,2,1),h1=imshow(I); 
% subplot(1,2,2),h2=imshow(D,[0 9000]); colormap('jet');

% Stop the Kinect Process
mxNiDeleteContext(KinectHandles);