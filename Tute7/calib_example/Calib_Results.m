% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 657.395348702923340 ; 657.763094441524800 ];

%-- Principal point:
cc = [ 302.983678000456620 ; 242.616302940066900 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.255839182939968 ; 0.127576673169686 ; -0.000208100825012 ; 0.000033479624751 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 0.346911746318220 ; 0.371112310079804 ];

%-- Principal point uncertainty:
cc_error = [ 0.705463811939230 ; 0.645527452704615 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.002706688248840 ; 0.010758228987162 ; 0.000145789087732 ; 0.000144007633107 ; 0.000000000000000 ];

%-- Image size:
nx = 640;
ny = 480;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 20;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 1.654779e+000 ; 1.651918e+000 ; -6.699925e-001 ];
Tc_1  = [ -1.775774e+002 ; -8.374084e+001 ; 8.529831e+002 ];
omc_error_1 = [ 8.237489e-004 ; 1.064559e-003 ; 1.360699e-003 ];
Tc_error_1  = [ 9.161028e-001 ; 8.447697e-001 ; 4.641402e-001 ];

%-- Image #2:
omc_2 = [ 1.849011e+000 ; 1.900560e+000 ; -3.971213e-001 ];
Tc_2  = [ -1.549645e+002 ; -1.593546e+002 ; 7.576048e+002 ];
omc_error_2 = [ 8.655039e-004 ; 1.057837e-003 ; 1.645355e-003 ];
Tc_error_2  = [ 8.179971e-001 ; 7.488546e-001 ; 4.562455e-001 ];

%-- Image #3:
omc_3 = [ 1.742391e+000 ; 2.077563e+000 ; -5.052451e-001 ];
Tc_3  = [ -1.252425e+002 ; -1.746277e+002 ; 7.754805e+002 ];
omc_error_3 = [ 7.921064e-004 ; 1.120867e-003 ; 1.700924e-003 ];
Tc_error_3  = [ 8.361743e-001 ; 7.663268e-001 ; 4.385831e-001 ];

%-- Image #4:
omc_4 = [ 1.827858e+000 ; 2.116776e+000 ; -1.103193e+000 ];
Tc_4  = [ -6.443332e+001 ; -1.548703e+002 ; 7.791043e+002 ];
omc_error_4 = [ 7.109839e-004 ; 1.161242e-003 ; 1.592719e-003 ];
Tc_error_4  = [ 8.427319e-001 ; 7.648944e-001 ; 3.533141e-001 ];

%-- Image #5:
omc_5 = [ 1.079052e+000 ; 1.922500e+000 ; -2.527477e-001 ];
Tc_5  = [ -9.224634e+001 ; -2.291555e+002 ; 7.366549e+002 ];
omc_error_5 = [ 6.944829e-004 ; 1.082856e-003 ; 1.219279e-003 ];
Tc_error_5  = [ 8.027145e-001 ; 7.298432e-001 ; 4.319024e-001 ];

%-- Image #6:
omc_6 = [ -1.701812e+000 ; -1.929291e+000 ; -7.914701e-001 ];
Tc_6  = [ -1.489024e+002 ; -7.964770e+001 ; 4.449783e+002 ];
omc_error_6 = [ 6.674800e-004 ; 1.081016e-003 ; 1.464361e-003 ];
Tc_error_6  = [ 4.810537e-001 ; 4.512357e-001 ; 3.694874e-001 ];

%-- Image #7:
omc_7 = [ 1.996748e+000 ; 1.931472e+000 ; 1.310634e+000 ];
Tc_7  = [ -8.293235e+001 ; -7.773534e+001 ; 4.401758e+002 ];
omc_error_7 = [ 1.278362e-003 ; 6.563940e-004 ; 1.535911e-003 ];
Tc_error_7  = [ 4.832971e-001 ; 4.409766e-001 ; 3.901099e-001 ];

%-- Image #8:
omc_8 = [ 1.961458e+000 ; 1.824261e+000 ; 1.326197e+000 ];
Tc_8  = [ -1.701121e+002 ; -1.035605e+002 ; 4.620732e+002 ];
omc_error_8 = [ 1.220036e-003 ; 6.695322e-004 ; 1.473027e-003 ];
Tc_error_8  = [ 5.283967e-001 ; 4.790943e-001 ; 4.394752e-001 ];

%-- Image #9:
omc_9 = [ -1.363691e+000 ; -1.980542e+000 ; 3.210319e-001 ];
Tc_9  = [ -1.878711e+000 ; -2.251588e+002 ; 7.286464e+002 ];
omc_error_9 = [ 8.318216e-004 ; 1.068291e-003 ; 1.376511e-003 ];
Tc_error_9  = [ 7.919950e-001 ; 7.188155e-001 ; 4.491840e-001 ];

%-- Image #10:
omc_10 = [ -1.513265e+000 ; -2.086817e+000 ; 1.882465e-001 ];
Tc_10  = [ -2.960784e+001 ; -3.004309e+002 ; 8.601618e+002 ];
omc_error_10 = [ 1.014556e-003 ; 1.214632e-003 ; 1.830495e-003 ];
Tc_error_10  = [ 9.517848e-001 ; 8.544740e-001 ; 5.961766e-001 ];

%-- Image #11:
omc_11 = [ -1.793085e+000 ; -2.064817e+000 ; -4.799214e-001 ];
Tc_11  = [ -1.510537e+002 ; -2.353638e+002 ; 7.047465e+002 ];
omc_error_11 = [ 9.101242e-004 ; 1.146143e-003 ; 1.970019e-003 ];
Tc_error_11  = [ 7.802687e-001 ; 7.317392e-001 ; 5.897813e-001 ];

%-- Image #12:
omc_12 = [ -1.839113e+000 ; -2.087345e+000 ; -5.155436e-001 ];
Tc_12  = [ -1.334802e+002 ; -1.772297e+002 ; 6.049746e+002 ];
omc_error_12 = [ 7.758649e-004 ; 1.101385e-003 ; 1.817447e-003 ];
Tc_error_12  = [ 6.645809e-001 ; 6.187298e-001 ; 4.931217e-001 ];

%-- Image #13:
omc_13 = [ -1.919019e+000 ; -2.116536e+000 ; -5.941698e-001 ];
Tc_13  = [ -1.326918e+002 ; -1.435601e+002 ; 5.448015e+002 ];
omc_error_13 = [ 7.237310e-004 ; 1.090138e-003 ; 1.786809e-003 ];
Tc_error_13  = [ 5.967563e-001 ; 5.538369e-001 ; 4.475421e-001 ];

%-- Image #14:
omc_14 = [ -1.954383e+000 ; -2.124577e+000 ; -5.844155e-001 ];
Tc_14  = [ -1.235974e+002 ; -1.371429e+002 ; 4.909029e+002 ];
omc_error_14 = [ 6.811546e-004 ; 1.068393e-003 ; 1.749258e-003 ];
Tc_error_14  = [ 5.384989e-001 ; 4.985603e-001 ; 4.016645e-001 ];

%-- Image #15:
omc_15 = [ -2.110763e+000 ; -2.253834e+000 ; -4.948457e-001 ];
Tc_15  = [ -1.991404e+002 ; -1.345095e+002 ; 4.750400e+002 ];
omc_error_15 = [ 7.861858e-004 ; 1.000604e-003 ; 1.906498e-003 ];
Tc_error_15  = [ 5.281411e-001 ; 4.944589e-001 ; 4.329014e-001 ];

%-- Image #16:
omc_16 = [ 1.886909e+000 ; 2.336195e+000 ; -1.735758e-001 ];
Tc_16  = [ -1.593424e+001 ; -1.703338e+002 ; 6.955668e+002 ];
omc_error_16 = [ 1.080868e-003 ; 1.141775e-003 ; 2.373491e-003 ];
Tc_error_16  = [ 7.512687e-001 ; 6.820887e-001 ; 5.126737e-001 ];

%-- Image #17:
omc_17 = [ -1.612908e+000 ; -1.953394e+000 ; -3.473542e-001 ];
Tc_17  = [ -1.352327e+002 ; -1.389560e+002 ; 4.901887e+002 ];
omc_error_17 = [ 6.730105e-004 ; 1.029433e-003 ; 1.450973e-003 ];
Tc_error_17  = [ 5.315842e-001 ; 4.945583e-001 ; 3.560028e-001 ];

%-- Image #18:
omc_18 = [ -1.341751e+000 ; -1.692559e+000 ; -2.970117e-001 ];
Tc_18  = [ -1.853693e+002 ; -1.577999e+002 ; 4.412934e+002 ];
omc_error_18 = [ 7.723996e-004 ; 1.000083e-003 ; 1.145505e-003 ];
Tc_error_18  = [ 4.832919e-001 ; 4.508077e-001 ; 3.458154e-001 ];

%-- Image #19:
omc_19 = [ -1.925985e+000 ; -1.837926e+000 ; -1.440322e+000 ];
Tc_19  = [ -1.065657e+002 ; -7.957188e+001 ; 3.341594e+002 ];
omc_error_19 = [ 6.643734e-004 ; 1.171549e-003 ; 1.484621e-003 ];
Tc_error_19  = [ 3.750237e-001 ; 3.440401e-001 ; 3.243328e-001 ];

%-- Image #20:
omc_20 = [ 1.896147e+000 ; 1.593137e+000 ; 1.471912e+000 ];
Tc_20  = [ -1.438343e+002 ; -8.803625e+001 ; 3.961774e+002 ];
omc_error_20 = [ 1.237531e-003 ; 6.846318e-004 ; 1.333991e-003 ];
Tc_error_20  = [ 4.577415e-001 ; 4.100509e-001 ; 3.923652e-001 ];

