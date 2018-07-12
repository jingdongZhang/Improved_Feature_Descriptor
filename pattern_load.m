%%% This function lets the user enter the name of the images (base name, numbering scheme,...
function pattern_load(calib_data)

%clear all;
set_up_global;
% Checks that there are some images in the directory:

display('----------------------------------------------------------------------'); 
display('### Load Pattern')
display('Input the path of the pattern'); 
[file, path] = uigetfile('*.jpg;*.tif;*.png;*.gif;*.bmp');
path = [path, file];

pattern = imread(path); 
if (size(pattern, 3) > 1)
    pattern = rgb2gray(pattern); 
end

display([path, ' successfully loaded']); 

display('### Resize Pattern')
display('Do you need to resize the pattern?'); 
display('If the pattern resolution is very high, '); 
display('suitable shrinking can help speed up and enhance the feature detection. '); 
scale = input('Input the scale ([] = no resize): '); 
if ~isempty(scale)
    pattern = imresize(pattern, scale); 
    display(['Resized to ', num2str(scale * 100), '%']); 
else
    display('Not resized'); 
end

   calib_data.pattern=pattern;


end

