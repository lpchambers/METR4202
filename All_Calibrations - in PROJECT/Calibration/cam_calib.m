% function cam_calib()

%FUnction Constants
%Number original images to take
Num_orig = 100;
%Number of randomly selected to save
Num_save = 10;



%Get and save the images
% [I, D] = get_images(Num_orig);
% save_images(I,D,Num_save);



%Now do image processing on the images
addpath('Calib_tool2');
%Use the Bouguejt Camera Calibration Toolbox
%All with edit_ have been slightly changed

%Load in already saved images
edit_data_calib;

%Get the corners for initial window (5,5)
global dx_in dy_in;
dx_in = 5;
dy_in = 5;
edit_click_calib;

%Run initial Calibration
go_calib_optim;

%close all open windows
close all;

%Gets the numbers to process
global edit_to_proc;

% edit_analyse_error;
edit_to_proc = 1:Num_save;
edit_recomp_corner_calib;

%Re-run Calibration on better guesses
go_calib_optim;