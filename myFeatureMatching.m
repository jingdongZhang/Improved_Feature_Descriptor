calibrationImage= imread('C:\Users\Administrator\Desktop\rms0.5\pattern.png');
pattern = imresize(calibrationImage, 0.5); 
display('Input the path of the pattern'); 
[file, path] = uigetfile('*.jpg;*.tif;*.png;*.gif;*.bmp');
path = [path, file];
realImage = imread(path);
%calib_data.minMatchedPoints =max(15, 20 / 1000 * calib_data.ocam_model.height); 
%calib_data.maxInitReprojectError = 20 / 1200 * calib_data.ocam_model.height; 
%calib_data.maxFinalReprojectError = 1.5; 
%calib_data.maxInlierError = 1; 
%calib_data.maxSmoothError = 80 / 1000 * calib_data.ocam_model.height;
%patternKeyPoints = detectSURFFeatures(pattern, 'NumOctaves', 3, 'NumScaleLevels', 3); 
patternKeyPoints = detectSURFFeatures(pattern);
[stanardpatternFeatures,stanardspatternPoints] = extractFeatures(pattern, patternKeyPoints);

myImage= histeq(realImage);
%photoKeyPoints = detectSURFFeatures(myImage, 'NumOctaves', 8, 'MetricThreshold', 1000);
photoKeyPoints = detectSURFFeatures(myImage);
[photoFeatures, photoPoints] = extractFeatures(myImage, photoKeyPoints);
% Descriptor matching
%indexPairs = matchFeatures(stanardpatternFeatures, photoFeatures, 'Method', 'NearestNeighborRatio'); 
indexPairs = matchFeatures(stanardpatternFeatures, photoFeatures,'Prenormalized', true);
display(['....Matches: ', num2str(size(indexPairs, 1))]); 

patternPoints = stanardspatternPoints(indexPairs(:, 1));
photoPoints = photoPoints(indexPairs(:, 2));
patternPoints =double(patternPoints(:).Location);
photoPoints = double(photoPoints(:).Location);

imshow(realImage);
hold on;
plot(photoPoints(:,1),photoPoints(:,2),'ro');
text(50,50,num2str(length(photoPoints)),'fontsize',40,'Editing','on','Color',[1 0 0]);