function [intrinsics, extrinsics] = cam_calib()
%Function Constants
%Number original images to take
Num_orig = 500;
%Number of randomly selected to save
Num_save = 40;
%Wintx/y variables
Wintin = 4:10;

%Get and save the images
% [I, D] = get_images(Num_orig);
% save_images(I,D,Num_save);

%Now do image processing on the images
addpath('Calib_tool2');
%Use the Bouguejt Camera Calibration Toolbox
%Actually use the RADOCC toolbox
%All with edit_ have been slightly changed

%Load in already saved images
edit_data_calib;

%Get the corners for initial window (5,5)
global dx_in dy_in;
dx_in = 5;
dy_in = 5;
edit_click_calib;

%close any additional pop-ups
close all;

%Run initial Calibration
go_calib_optim;

%close all open windows
close all;

%Gets the numbers to process
global edit_to_proc;

%Reprocess all corners
edit_to_proc = 1:Num_save;
edit_recomp_corner_calib;

%Re-run Calibration on better guesses
go_calib_optim;
best_fcerror = fc_error;

is_it_good = input('Are we happy with these results (and errors)? [] = No; Other = Yes: ');
%Keep going until we are happy with results
%Change later to be better aim for accuracy
while isempty(is_it_good)
    %This saves selected point in edit_to_proc
    edit_analyse_error;
    
    %This finds the best window for it
    %Assume 5 is default best
    best_win = 5;
    for i=Wintin;
        dx_in = i;
        dy_in = i;
        edit_recomp_corner_calib;
        go_calib_optim;
        if fc_error < best_fcerror
            best_fcerror = fc_error;
            best_win = i;
        end;
    end;
    %Reset with best window
    dx_in = best_win;
    dy_in = best_win;
    edit_recomp_corner_calib;
    go_calib_optim;
    close all;
    is_it_good = input('Are we happy with these results (and errors)? [] = No; Other = Yes: ');
end;
saving_calib;

%Return the values
intrinsics = struct();
intrinsics.fc = fc';
intrinsics.cc = cc';
intrinsics.alpha_c = alpha_c;
intrinsics.kc = kc';
intrinsics.err = err_std';
trans_m = zeros(4,4,n_ima);
for i=1:n_ima
    trans_m(:,:,i) = eval(['[Rc_' num2str(i) ',Tc_' num2str(i) ';0,0,0,1]']);
end;
extrinsics.transformation_matrices = trans_m;