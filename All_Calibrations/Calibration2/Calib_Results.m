% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 549.328161253298160 ; 547.419982034144370 ];

%-- Principal point:
cc = [ 298.621191965191660 ; 261.645268388447850 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ 0.198371901890960 ; -0.276429564128404 ; 0.003169337076636 ; -0.001552807099200 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 5.419302479756110 ; 5.966060163408327 ];

%-- Principal point uncertainty:
cc_error = [ 5.604552812853888 ; 5.869120567857842 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.028105185120934 ; 0.058283563996895 ; 0.005614369971910 ; 0.004285793326913 ; 0.000000000000000 ];

%-- Image size:
nx = 640;
ny = 480;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 40;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 5.180717e-01 ; 7.396857e-01 ; 1.541620e+00 ];
Tc_1  = [ 2.123947e+01 ; -2.971004e+01 ; 7.426938e+01 ];
omc_error_1 = [ 1.269582e-02 ; 1.349122e-02 ; 5.018494e-03 ];
Tc_error_1  = [ 7.899950e-01 ; 8.224680e-01 ; 9.691182e-01 ];

%-- Image #2:
omc_2 = [ -2.080036e-01 ; -3.642895e-02 ; 1.615148e+00 ];
Tc_2  = [ 1.448913e+01 ; -3.289938e+01 ; 8.852231e+01 ];
omc_error_2 = [ 1.698890e-02 ; 1.665928e-02 ; 4.277215e-03 ];
Tc_error_2  = [ 9.310777e-01 ; 9.419435e-01 ; 9.283070e-01 ];

%-- Image #3:
omc_3 = [ -6.104565e-01 ; -4.220065e-01 ; 1.523327e+00 ];
Tc_3  = [ 7.233555e+00 ; -2.668764e+01 ; 9.512535e+01 ];
omc_error_3 = [ 1.493328e-02 ; 1.426335e-02 ; 6.391524e-03 ];
Tc_error_3  = [ 9.934176e-01 ; 1.010731e+00 ; 8.839058e-01 ];

%-- Image #4:
omc_4 = [ -9.806006e-02 ; -1.511407e-01 ; 1.567122e+00 ];
Tc_4  = [ 1.160198e+01 ; -3.276395e+01 ; 8.170133e+01 ];
omc_error_4 = [ 1.914890e-02 ; 1.909741e-02 ; 3.975921e-03 ];
Tc_error_4  = [ 8.639163e-01 ; 8.727759e-01 ; 8.899817e-01 ];

%-- Image #5:
omc_5 = [ 2.578183e-01 ; -3.525397e-01 ; 1.594787e+00 ];
Tc_5  = [ 1.283636e+01 ; -2.918136e+01 ; 7.037474e+01 ];
omc_error_5 = [ 1.970963e-02 ; 2.069358e-02 ; 3.279742e-03 ];
Tc_error_5  = [ 7.470497e-01 ; 7.760881e-01 ; 8.229063e-01 ];

%-- Image #6:
omc_6 = [ 5.875488e-01 ; -6.743398e-01 ; 1.489962e+00 ];
Tc_6  = [ 1.373541e+01 ; -2.110174e+01 ; 6.240079e+01 ];
omc_error_6 = [ 1.309976e-02 ; 1.360016e-02 ; 4.564212e-03 ];
Tc_error_6  = [ 6.543454e-01 ; 6.737639e-01 ; 7.215862e-01 ];

%-- Image #7:
omc_7 = [ 3.148973e-01 ; -3.830818e-01 ; 1.552513e+00 ];
Tc_7  = [ 1.344923e+01 ; -2.666440e+01 ; 6.513332e+01 ];
omc_error_7 = [ 1.692749e-02 ; 1.758177e-02 ; 3.105724e-03 ];
Tc_error_7  = [ 6.923019e-01 ; 7.148715e-01 ; 7.539428e-01 ];

%-- Image #8:
omc_8 = [ 6.322940e-02 ; -1.453564e-01 ; 1.550184e+00 ];
Tc_8  = [ 1.274760e+01 ; -3.046054e+01 ; 7.098848e+01 ];
omc_error_8 = [ 1.913157e-02 ; 1.974437e-02 ; 3.017567e-03 ];
Tc_error_8  = [ 7.516540e-01 ; 7.726213e-01 ; 8.293210e-01 ];

%-- Image #9:
omc_9 = [ -5.745461e-02 ; -2.549866e-02 ; 1.544703e+00 ];
Tc_9  = [ 1.247538e+01 ; -3.128330e+01 ; 7.401915e+01 ];
omc_error_9 = [ 1.653025e-02 ; 1.681619e-02 ; 3.270722e-03 ];
Tc_error_9  = [ 7.832324e-01 ; 7.917652e-01 ; 8.268021e-01 ];

%-- Image #10:
omc_10 = [ -3.558014e-01 ; 2.314001e-01 ; 1.507928e+00 ];
Tc_10  = [ 1.155820e+01 ; -3.181279e+01 ; 8.226631e+01 ];
omc_error_10 = [ 1.291427e-02 ; 1.309662e-02 ; 4.584846e-03 ];
Tc_error_10  = [ 8.673204e-01 ; 8.674270e-01 ; 8.267376e-01 ];

%-- Image #11:
omc_11 = [ -7.114916e-01 ; 4.306908e-01 ; 1.464319e+00 ];
Tc_11  = [ 1.066853e+01 ; -2.712508e+01 ; 9.481236e+01 ];
omc_error_11 = [ 1.162072e-02 ; 1.192644e-02 ; 6.355835e-03 ];
Tc_error_11  = [ 9.846679e-01 ; 9.973229e-01 ; 8.678625e-01 ];

%-- Image #12:
omc_12 = [ -4.018785e-01 ; 1.917431e-01 ; 1.563465e+00 ];
Tc_12  = [ 1.221133e+01 ; -2.707890e+01 ; 8.381320e+01 ];
omc_error_12 = [ 1.323124e-02 ; 1.318546e-02 ; 4.518871e-03 ];
Tc_error_12  = [ 8.728143e-01 ; 8.808825e-01 ; 8.193515e-01 ];

%-- Image #13:
omc_13 = [ -2.375492e-01 ; 5.993532e-02 ; 1.584073e+00 ];
Tc_13  = [ 1.259694e+01 ; -2.620821e+01 ; 7.856887e+01 ];
omc_error_13 = [ 1.488499e-02 ; 1.467992e-02 ; 3.657399e-03 ];
Tc_error_13  = [ 8.175897e-01 ; 8.281005e-01 ; 8.078919e-01 ];

%-- Image #14:
omc_14 = [ -2.241373e-01 ; 6.271375e-02 ; 1.582190e+00 ];
Tc_14  = [ 1.242213e+01 ; -2.638011e+01 ; 7.865272e+01 ];
omc_error_14 = [ 1.501074e-02 ; 1.483241e-02 ; 3.622547e-03 ];
Tc_error_14  = [ 8.187378e-01 ; 8.293302e-01 ; 8.129639e-01 ];

%-- Image #15:
omc_15 = [ -6.738198e-02 ; 1.846363e-01 ; 1.630059e+00 ];
Tc_15  = [ 1.351684e+01 ; -2.623958e+01 ; 7.576494e+01 ];
omc_error_15 = [ 1.493418e-02 ; 1.508443e-02 ; 3.129374e-03 ];
Tc_error_15  = [ 7.907250e-01 ; 8.059705e-01 ; 8.343955e-01 ];

%-- Image #16:
omc_16 = [ 1.782782e-01 ; 3.956929e-01 ; 1.592549e+00 ];
Tc_16  = [ 1.184402e+01 ; -2.615088e+01 ; 7.093066e+01 ];
omc_error_16 = [ 1.326271e-02 ; 1.382224e-02 ; 3.424600e-03 ];
Tc_error_16  = [ 7.450751e-01 ; 7.650483e-01 ; 8.365875e-01 ];

%-- Image #17:
omc_17 = [ 5.616688e-01 ; 8.511471e-02 ; 1.864677e+00 ];
Tc_17  = [ 1.169450e+01 ; -1.889873e+01 ; 6.140117e+01 ];
omc_error_17 = [ 1.550410e-02 ; 1.586363e-02 ; 3.746895e-03 ];
Tc_error_17  = [ 6.499633e-01 ; 6.783778e-01 ; 8.075894e-01 ];

%-- Image #18:
omc_18 = [ NaN ; NaN ; NaN ];
Tc_18  = [ NaN ; NaN ; NaN ];
omc_error_18 = [ NaN ; NaN ; NaN ];
Tc_error_18  = [ NaN ; NaN ; NaN ];

%-- Image #19:
omc_19 = [ NaN ; NaN ; NaN ];
Tc_19  = [ NaN ; NaN ; NaN ];
omc_error_19 = [ NaN ; NaN ; NaN ];
Tc_error_19  = [ NaN ; NaN ; NaN ];

%-- Image #20:
omc_20 = [ NaN ; NaN ; NaN ];
Tc_20  = [ NaN ; NaN ; NaN ];
omc_error_20 = [ NaN ; NaN ; NaN ];
Tc_error_20  = [ NaN ; NaN ; NaN ];

%-- Image #21:
omc_21 = [ NaN ; NaN ; NaN ];
Tc_21  = [ NaN ; NaN ; NaN ];
omc_error_21 = [ NaN ; NaN ; NaN ];
Tc_error_21  = [ NaN ; NaN ; NaN ];

%-- Image #22:
omc_22 = [ NaN ; NaN ; NaN ];
Tc_22  = [ NaN ; NaN ; NaN ];
omc_error_22 = [ NaN ; NaN ; NaN ];
Tc_error_22  = [ NaN ; NaN ; NaN ];

%-- Image #23:
omc_23 = [ 6.750925e-01 ; -9.800139e-01 ; 1.723770e+00 ];
Tc_23  = [ 1.803502e+01 ; -1.292157e+01 ; 5.664555e+01 ];
omc_error_23 = [ 1.264170e-02 ; 1.408712e-02 ; 6.482387e-03 ];
Tc_error_23  = [ 5.839302e-01 ; 6.159030e-01 ; 6.338652e-01 ];

%-- Image #24:
omc_24 = [ 4.484414e-01 ; -6.822746e-01 ; 1.538797e+00 ];
Tc_24  = [ 1.607720e+01 ; -1.875281e+01 ; 5.681469e+01 ];
omc_error_24 = [ 1.366887e-02 ; 1.426142e-02 ; 4.287999e-03 ];
Tc_error_24  = [ 5.939737e-01 ; 6.140988e-01 ; 6.387190e-01 ];

%-- Image #25:
omc_25 = [ 4.231333e-01 ; -6.459396e-01 ; 1.530694e+00 ];
Tc_25  = [ 1.580687e+01 ; -1.927060e+01 ; 5.713915e+01 ];
omc_error_25 = [ 1.398986e-02 ; 1.451611e-02 ; 4.100099e-03 ];
Tc_error_25  = [ 5.980852e-01 ; 6.177598e-01 ; 6.432025e-01 ];

%-- Image #26:
omc_26 = [ -6.150724e-02 ; -8.365744e-02 ; 1.568679e+00 ];
Tc_26  = [ 1.421345e+01 ; -2.366031e+01 ; 6.481239e+01 ];
omc_error_26 = [ 1.779004e-02 ; 1.753039e-02 ; 3.202077e-03 ];
Tc_error_26  = [ 6.770764e-01 ; 6.946729e-01 ; 7.235461e-01 ];

%-- Image #27:
omc_27 = [ -7.510331e-01 ; 6.050930e-01 ; 1.353381e+00 ];
Tc_27  = [ 1.201096e+01 ; -2.989207e+01 ; 8.870801e+01 ];
omc_error_27 = [ 1.117773e-02 ; 1.189676e-02 ; 7.488782e-03 ];
Tc_error_27  = [ 9.290312e-01 ; 9.395724e-01 ; 8.418870e-01 ];

%-- Image #28:
omc_28 = [ -7.746714e-01 ; 6.310585e-01 ; 1.345246e+00 ];
Tc_28  = [ 1.193860e+01 ; -2.981494e+01 ; 9.005550e+01 ];
omc_error_28 = [ 1.110073e-02 ; 1.186739e-02 ; 7.673403e-03 ];
Tc_error_28  = [ 9.422892e-01 ; 9.540155e-01 ; 8.529039e-01 ];

%-- Image #29:
omc_29 = [ -7.261265e-01 ; 7.543531e-01 ; 1.751654e+00 ];
Tc_29  = [ 1.621522e+01 ; -2.053435e+01 ; 7.970527e+01 ];
omc_error_29 = [ 1.598452e-02 ; 1.626856e-02 ; 1.031164e-02 ];
Tc_error_29  = [ 8.240790e-01 ; 8.671212e-01 ; 9.305689e-01 ];

%-- Image #30:
omc_30 = [ -3.290014e-01 ; 7.265471e-01 ; 2.106030e+00 ];
Tc_30  = [ 2.569240e+01 ; -2.588418e+01 ; 8.239665e+01 ];
omc_error_30 = [ 1.312897e-02 ; 1.343801e-02 ; 5.921213e-03 ];
Tc_error_30  = [ 8.602016e-01 ; 8.981376e-01 ; 9.366362e-01 ];

%-- Image #31:
omc_31 = [ 2.323013e-01 ; 3.022780e-01 ; 1.377774e+00 ];
Tc_31  = [ 2.852751e+01 ; -2.568797e+01 ; 6.233796e+01 ];
omc_error_31 = [ 2.856829e-02 ; 2.778541e-02 ; 4.823411e-03 ];
Tc_error_31  = [ 6.782829e-01 ; 7.057387e-01 ; 8.406269e-01 ];

%-- Image #32:
omc_32 = [ 1.772938e-01 ; 2.477296e-01 ; 1.431864e+00 ];
Tc_32  = [ 2.329126e+01 ; -2.835776e+01 ; 6.767965e+01 ];
omc_error_32 = [ 5.652183e-02 ; 5.514017e-02 ; 1.103975e-02 ];
Tc_error_32  = [ 7.522804e-01 ; 7.880265e-01 ; 1.021758e+00 ];

%-- Image #33:
omc_33 = [ 2.350150e-01 ; 2.685054e-01 ; 1.468475e+00 ];
Tc_33  = [ 3.550782e+01 ; -2.805046e+01 ; 6.475567e+01 ];
omc_error_33 = [ 4.037583e-02 ; 3.684415e-02 ; 6.841137e-03 ];
Tc_error_33  = [ 7.082808e-01 ; 7.676262e-01 ; 1.028727e+00 ];

%-- Image #34:
omc_34 = [ NaN ; NaN ; NaN ];
Tc_34  = [ NaN ; NaN ; NaN ];
omc_error_34 = [ NaN ; NaN ; NaN ];
Tc_error_34  = [ NaN ; NaN ; NaN ];

%-- Image #35:
omc_35 = [ NaN ; NaN ; NaN ];
Tc_35  = [ NaN ; NaN ; NaN ];
omc_error_35 = [ NaN ; NaN ; NaN ];
Tc_error_35  = [ NaN ; NaN ; NaN ];

%-- Image #36:
omc_36 = [ NaN ; NaN ; NaN ];
Tc_36  = [ NaN ; NaN ; NaN ];
omc_error_36 = [ NaN ; NaN ; NaN ];
Tc_error_36  = [ NaN ; NaN ; NaN ];

%-- Image #37:
omc_37 = [ NaN ; NaN ; NaN ];
Tc_37  = [ NaN ; NaN ; NaN ];
omc_error_37 = [ NaN ; NaN ; NaN ];
Tc_error_37  = [ NaN ; NaN ; NaN ];

%-- Image #38:
omc_38 = [ NaN ; NaN ; NaN ];
Tc_38  = [ NaN ; NaN ; NaN ];
omc_error_38 = [ NaN ; NaN ; NaN ];
Tc_error_38  = [ NaN ; NaN ; NaN ];

%-- Image #39:
omc_39 = [ NaN ; NaN ; NaN ];
Tc_39  = [ NaN ; NaN ; NaN ];
omc_error_39 = [ NaN ; NaN ; NaN ];
Tc_error_39  = [ NaN ; NaN ; NaN ];

%-- Image #40:
omc_40 = [ NaN ; NaN ; NaN ];
Tc_40  = [ NaN ; NaN ; NaN ];
omc_error_40 = [ NaN ; NaN ; NaN ];
Tc_error_40  = [ NaN ; NaN ; NaN ];

