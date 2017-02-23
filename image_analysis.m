% 1. Read in the image “Parrots.jpg”.
img = imread('C:\tmp\Parrots.jpg');
%{
2. Display the size of an image “Parrots.jpg” on the screen. It should be
something like (A B 3), where A × B is the number of pixels in each plane, 
and the image has 3 planes
%}
disp(size(img));

%{
3. Display the maximum value in the 1st plane of the image on the screen
%}
R = img(:,:,1); % Red
max_R = max(R(:)); % max value in first layer (Red)
disp(max_R);

%{
4. Display the minimum value in the second plane of the image on the 
screen
%}
G = img(:,:,2); % Green
min_G = min(G(:)); % min value in the second layer (Green)
disp(min_G);

%{ 
5. Display how many elements (i.e. pixels) in the third plane of image 
is greater than 150
%}
B = img(:,:,3); % Blue
greater_than_150 = B>150;
disp(sum(greater_than_150(:)))
