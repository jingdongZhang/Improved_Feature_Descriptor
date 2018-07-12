# Improved_Feature_Descriptor
      This is an add-on to the Li et al toolbox by Jingdong Zhang. 
      This repository contains addon files for Li et al Toolbox. More information about the addon can be found in the paper. If you use the addons, consider citing it.<br>

      @Article{JingdongCalibration,
      Title={{An Online Automatic Calibration Method Based on Feature Descriptor for Non-Overlapping Multi-Camera System},
      Author={Long Zhang, Jingdong Zhang, Wen Zhang,  Chaofan Zhang, Yong Liu},
      Journal={IEEE International Conference on Robotics and Biomimetics (ROBIO)},
      Year={2018}
      }


# Calibration and Tests
      
   1. Run ocam_calibJingdong.m !!! (instead of ocam_calib)
   2. press (in that order)
   * Load Pattern
   * Read names
   * Extract feature
   * Calibration
   * No-linear Refinement
   * Save
   * Load
   * Export Data
   * Exit


# An example

Improved_Feature_Descriptor　by jingdongzhang
### Load Pattern
Input the path of the pattern
C:\Users\Administrator\Desktop\github\rms0.5\Improved_Scaramuzza_OCamCalib\pattern.png successfully loaded
### Resize Pattern
Do you need to resize the pattern?
If the pattern resolution is very high, 
suitable shrinking can help speed up and enhance the feature detection. 
Input the scale ([] = no resize): 0.5
Resized to 50%

.                                  loading_calib.m                    ma5.bmp                            
..                                 loadpgm.m                          ma5.jpg                            
C_calib_data.m                     loadppm.m                          ma6.bmp                            
FUNrho.m                           m1.bmp                             ma6.jpg                            
FisheyeDataSet                     m1.jpg                             ma7.bmp                            
Ocam_calibJingdong.m               m10.bmp                            ma7.jpg                            
Step1_perform_test_calibrations.m  m10.jpg                            ma8.bmp                            
Step2_compare_results.m            m11.bmp                            ma8.jpg                            
add_suppress.m                     m11.jpg                            ma9.bmp                            
analyse_error.m                    m12.bmp                            ma9.jpg                            
autoCornerFinder                   m12.jpg                            mosaic.m                           
bundleAdjustmentUrban.m            m13.bmp                            myFeatureMatching.m                
bundleAdjustmentZJD.m              m13.jpg                            ocam_calib.m                       
bundleErrUrban.m                   m14.bmp                            ocam_calibUrban.m                  
bundleErrZJD.m                     m14.jpg                            ocam_calib_gui.m                   
calibrate.m                        m15.bmp                            ocam_calib_guiUrban.m              
calibrateZJD.m                     m15.jpg                            omni3d2pixel.m                     
calibrateZJD_test.m                m16.bmp                            omni_find_extrs_parameters.m       
calibration.m                      m16.jpg                            omni_find_intrs_parameters.m       
calibrationZJD.m                   m17.bmp                            optimizefunction.m                 
cam2world.m                        m17.jpg                            optimizefunction_all.m             
check_active_images.m              m18.bmp                            optimizefunction_old.m             
check_directory.m                  m18.jpg                            optimizeintpar.m                   
checkerboard_sizes.txt             m19.bmp                            pattern.jpg                        
click_calib.m                      m19.jpg                            pattern.pdf                        
click_calibUrban.m                 m2.bmp                             pattern.png                        
click_calibZJD.m                   m2.jpg                             pattern_load.m                     
click_ima_calib.m                  m3.bmp                             planefrompoints.m                  
click_ima_calib_rufli.m            m3.jpg                             prova.m                            
cornerfinder.m                     m4.bmp                             prova1.m                           
create_simulation_points.m         m4.jpg                             prova2.m                           
data_calib.m                       m5.bmp                             prova3.m                           
draw_axes.m                        m5.jpg                             prova_all.m                        
errCenterUrban.m                   m6.bmp                             randsample.m                       
eulerFromR.m                       m6.jpg                             readras.m                          
exportData2TXT.m                   m7.bmp                             recomp_corner_calib.m              
export_data.m                      m7.jpg                             reproject_calib.m                  
findcenter.m                       m8.bmp                             reprojectpoints.m                  
findcenterUrban.m                  m8.jpg                             reprojectpoints_adv.m              
findinvpoly.m                      m9.bmp                             reprojectpoints_fun.m              
findinvpolyUrban.m                 m9.jpg                             reprojectpoints_fun_adv.m          
generate_sim_points.m              ma1.bmp                            reprojectpoints_fun_adv_all.m      
get_best_checkerboard_images.m     ma1.jpg                            reprojectpoints_quiet.m            
get_checkerboard_corners.m         ma10.bmp                           rodrigues.m                        
get_checkerboard_cornersUrban.m    ma10.jpg                           sampleImage1                       
get_color_from_imagepoints.m       ma11.bmp                           sampleImage2                       
get_featureboard_features_ZJD.m    ma11.jpg                           saving_calib.m                     
get_ocam_model.m                   ma12.bmp                           set_up_global.m                    
getpoint.m                         ma12.jpg                           show_calib_results.m               
ginput3.m                          ma2.bmp                            undistort.m                        
huatu.m                            ma2.jpg                            utils                              
huatu2.m                           ma3.bmp                            world2cam.m                        
ima_read_calib.m                   ma3.jpg                            world2cam_fast.m                   
imagelist.yaml                     ma4.bmp                            
imunwrap.m                         ma4.jpg                            


Basename camera calibration images (without number nor suffix): ma
Image format: ([]='r'='ras', 'b'='bmp', 't'='tif', 'g'='gif', 'p'='pgm', 'j'='jpg', 'm'='ppm') j
Loading image 1...2...3...4...5...6...7...8...9...10...11...12...
done

Extraction feature on the images

Type the images you want to process (e.g. [1 2 3], [] = all images) = 
X coordinate (along height) of the omnidirectional image center = ([]=240) = 
Y coordinate (along width) of the omnidirectional image center = ([]=376) = 

EXTRACTION OF THE Features

Processing image ma1.jpg.......Matches: 29
....Matches after Fundam. Check: 27
....Matches after smoothness Check: 27
....27 features kept

Processing image ma2.jpg.......Matches: 99
....Matches after Fundam. Check: 83
....Matches after smoothness Check: 82
....82 features kept

Processing image ma3.jpg.......Matches: 106
....Matches after Fundam. Check: 91
....Matches after smoothness Check: 86
....86 features kept

Processing image ma4.jpg.......Matches: 65
....Matches after Fundam. Check: 54
....Matches after smoothness Check: 51
....51 features kept

Processing image ma5.jpg.......Matches: 79
....Matches after Fundam. Check: 64
....Matches after smoothness Check: 60
....60 features kept

Processing image ma6.jpg.......Matches: 116
....Matches after Fundam. Check: 90
....Matches after smoothness Check: 70
....70 features kept

Processing image ma7.jpg.......Matches: 65
....Matches after Fundam. Check: 49
....Matches after smoothness Check: 45
....45 features kept

Processing image ma8.jpg.......Matches: 65
....Matches after Fundam. Check: 52
....Matches after smoothness Check: 52
....52 features kept

Processing image ma9.jpg.......Matches: 91
....Matches after Fundam. Check: 67
....Matches after smoothness Check: 57
....57 features kept

Processing image ma10.jpg.......Matches: 37
....Matches after Fundam. Check: 32
....Matches after smoothness Check: 31
....31 features kept

Processing image ma11.jpg.......Matches: 86
....Matches after Fundam. Check: 69
....Matches after smoothness Check: 67
....67 features kept

Processing image ma12.jpg.......Matches: 84
....Matches after Fundam. Check: 67
....Matches after smoothness Check: 60
....60 features kept

Corner extraction finished.

Degree of polynomial expansion ([]=4) = 

 Average reprojection error computed for each chessboard [pixels]:

 0.80 ± 0.53
 0.51 ± 0.30
 0.54 ± 0.28
 0.54 ± 0.35
 0.57 ± 0.33
 0.52 ± 0.33
 0.60 ± 0.35

 Average error [pixels]

 0.582924

ss =

   1.0e+02 *

  -2.232897244974347
                   0
   0.000022504027203
  -0.000000066007032
   0.000000000190014

Starting non-linear refinement

ss =

   1.0e+02 *

  -2.212475831889427
                   0
   0.000015263303107
   0.000000005655185
   0.000000000006391

Root mean square[pixel]:  0.391378
Mean square error[pixel]:  0.298972
done

Loading calibration results from Omni_Calib_Results.mat
done
Exporting ocam_model to "calib_results.txt"
done
Bye. To run again, type ocam_calib.
