%function metr4202
%A place where you can run all of the calls from


cell_list = {};


%-------- Begin editable region -------------%
%-------- Begin editable region -------------%


fig_number = 1;

title_figure = 'METR4202 - Show me the money';

cell_list{1,1} = {'Colour Calibration','data_calib;'};
cell_list{1,2} = {'Camera Calibration (kinect)','[intrinsics, extrinsics] = cam_calib(1)'};
cell_list{2,1} = {'Camera Calibration (existing)','[intrinsics, extrinsics] = cam_calib(0)'};
cell_list{2,2} = {'Object Segmentation (kinect)','[money, coin_array, notes] = segment_count(1,0)'};
cell_list{3,1} = {'Object Segmentation (existing)','[money, coin_array, notes] = segment_count(0,0)'};
cell_list{3,2} = {'Object Segmentation (steps)','[money, coin_array, notes] = segment_count(0,1)'};
cell_list{4,1} = {'Localise Camera (kinect)','[campos, coinpos] = local_map(1,0)'};
cell_list{4,2} = {'Localise Camera (existing)','[campos, coinpos] = local_map(0,0)'};
cell_list{5,1} = {'Localise Coins (existing only)','[campos, coinpos] = local_map(0,1)'};
cell_list{5,2} = {'Exit',['disp(''Bye. To run again, type metr4202.''); close(' num2str(fig_number) ');']};
%cell_list{5,1} = {'Smooth images','smooth_images;'};


show_window(cell_list,fig_number,title_figure,200,18,2,'clean',12);


%-------- End editable region -------------%
%-------- End editable region -------------%